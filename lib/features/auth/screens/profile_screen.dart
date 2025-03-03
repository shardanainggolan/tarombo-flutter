import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tarombo/features/auth/providers/auth_provider.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:tarombo/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final personId = ref.watch(currentPersonIdProvider);
    final personAsync =
        personId != null ? ref.watch(personDetailsProvider(personId)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Nama', user?.name ?? '-'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Email', user?.email ?? '-'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Linked person
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Silsilah Terhubung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (personAsync == null) ...[
                      const Text(
                        'Anda belum menghubungkan data silsilah',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Cari dan Hubungkan Data',
                        icon: Icons.search,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.search);
                        },
                      ),
                    ] else ...[
                      personAsync.when(
                        data: (person) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Nama', person.fullName),
                            const SizedBox(height: 8),
                            _buildInfoRow('Marga', person.margaName ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Jenis Kelamin',
                              person.gender == 'male'
                                  ? 'Laki-laki'
                                  : 'Perempuan',
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    label: 'Lihat Silsilah',
                                    icon: Icons.account_tree,
                                    onPressed: () {
                                      context.go(AppRoutes.familyTree);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CustomButton(
                                  label: 'Ganti',
                                  icon: Icons.link,
                                  isOutlined: true,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.search);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stackTrace) => Text(
                          'Error: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            CustomButton(
              label: 'Keluar',
              color: Colors.red,
              icon: Icons.logout,
              onPressed: () {
                _showLogoutConfirmation(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
