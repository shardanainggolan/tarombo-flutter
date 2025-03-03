import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:tarombo/features/auth/providers/auth_provider.dart';
import 'package:tarombo/features/auth/screens/profile_screen.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final personId = ref.watch(currentPersonIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarombo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'Horas, ${user?.name ?? 'Pengguna'}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              personId != null
                  ? 'Silahkan jelajahi silsilah keluarga Anda'
                  : 'Hubungkan data silsilah untuk mulai menjelajah',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Main menu
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  'Silsilah Keluarga',
                  Icons.account_tree,
                  Colors.blue,
                  () {
                    if (personId != null) {
                      // Navigator.pushNamed(context, AppRoutes.familyTree);
                      GoRouter.of(context).go(AppRoutes.familyTree);
                    } else {
                      _showLinkPersonDialog(context);
                    }
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Partuturan',
                  Icons.people,
                  Colors.green,
                  () {
                    if (personId != null) {
                      // Navigator.pushNamed(context, AppRoutes.relationship);

                      GoRouter.of(context).go(AppRoutes.relationship);
                    } else {
                      _showLinkPersonDialog(context);
                    }
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Cari Orang',
                  Icons.search,
                  Colors.orange,
                  () {
                    Navigator.pushNamed(context, AppRoutes.search);
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Tentang Batak Toba',
                  Icons.info,
                  Colors.purple,
                  () {
                    // Navigate to info page
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick access section
            const Text(
              'Akses Cepat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickAccessCard(
              context,
              'Temukan & Hubungkan Data Diri',
              'Hubungkan data silsilah Anda untuk melihat seluruh keluarga',
              Icons.link,
              Colors.teal,
              () {
                // Navigator.pushNamed(context, AppRoutes.search);
                context.go(AppRoutes.search);
              },
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              context,
              'Panduan Partuturan',
              'Pelajari istilah kekerabatan dalam adat Batak Toba',
              Icons.menu_book,
              Colors.indigo,
              () {
                // Navigate to partuturan guide
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLinkPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungkan Data Diri'),
        content: const Text(
          'Anda perlu menghubungkan data diri terlebih dahulu untuk mengakses fitur ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.search);
            },
            child: const Text('Cari Data'),
          ),
        ],
      ),
    );
  }
}
