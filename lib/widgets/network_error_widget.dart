import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/core/services/connectivity_service.dart';

class NetworkErrorWidget extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    Key? key,
    required this.child,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    if (networkStatus == NetworkStatus.offline) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tidak ada koneksi internet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Periksa koneksi internet Anda dan coba lagi',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                onPressed: () async {
                  final connectivityService =
                      ref.read(connectivityServiceProvider);
                  final isConnected = await connectivityService.isConnected();

                  if (isConnected) {
                    ref.read(networkStatusProvider.notifier).state =
                        NetworkStatus.online;
                    if (onRetry != null) {
                      onRetry!();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
