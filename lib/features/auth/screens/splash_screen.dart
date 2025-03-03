import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/auth/providers/auth_provider.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    // Access auth state only if widget is still mounted
    final authState = ref.read(authStateProvider.notifier);
    await authState.checkLoginStatus();

    // Perform another mounted check after async operation
    if (!mounted) return;

    // Now safe to navigate
    if (ref.read(authStateProvider) != null) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/tarombo_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const Text(
              'TAROMBO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Menjaga Tradisi Silsilah Batak Toba',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
