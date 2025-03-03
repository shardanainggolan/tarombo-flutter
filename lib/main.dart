import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/config/router/app_router.dart';
import 'package:tarombo/config/theme/app_theme.dart';
import 'package:tarombo/core/services/storage_service.dart';
import 'package:tarombo/core/services/connectivity_service.dart';
import 'package:tarombo/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final connectivityService = ConnectivityService();
  final logger = AppLogger();

  logger.info('Starting Tarombo application');

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        connectivityServiceProvider.overrideWithValue(connectivityService),
        loggerProvider.overrideWithValue(logger),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final StreamSubscription<NetworkStatus> _networkStatusSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // Defer connectivity setup to post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupConnectivityListener();
    });
  }

  void _setupConnectivityListener() {
    final connectivityService = ref.read(connectivityServiceProvider);
    _networkStatusSubscription = connectivityService.status.listen((status) {
      ref.read(networkStatusProvider.notifier).state = status;

      if (status == NetworkStatus.offline) {
        _showConnectivitySnackBar('No internet connection');
      } else {
        _showConnectivitySnackBar('Back online');
      }
    });
  }

  void _showConnectivitySnackBar(String message) {
    // Use GlobalKey to access ScaffoldMessenger directly
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: message.contains('No') ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: _scaffoldMessengerKey, // Add this line
      title: 'Tarombo - Batak Toba Family Tree',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Banner(
          message: 'BETA',
          location: BannerLocation.topEnd,
          color: Colors.orange,
          child: child!,
        );
      },
    );
  }
}
