import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:tarombo/features/auth/providers/auth_provider.dart';

// Auth screens
import 'package:tarombo/features/auth/screens/login_screen.dart';
import 'package:tarombo/features/auth/screens/register_screen.dart';
import 'package:tarombo/features/auth/screens/splash_screen.dart';
import 'package:tarombo/features/auth/screens/profile_screen.dart';

// Family tree screens
import 'package:tarombo/features/family_tree/screens/family_tree_screen.dart';
import 'package:tarombo/features/family_tree/screens/person_detail_screen.dart';
import 'package:tarombo/features/family_tree/screens/relationship_screen.dart';

// Home and search screens
import 'package:tarombo/features/home/screens/home_screen.dart';
import 'package:tarombo/features/search/screens/search_screen.dart';

// Other screens
import 'package:tarombo/features/partuturan/screens/partuturan_guide_screen.dart';
import 'package:tarombo/features/info/screens/about_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home/Dashboard
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Family Tree routes
      GoRoute(
        path: AppRoutes.familyTree,
        builder: (context, state) {
          final personId =
              int.tryParse(state.pathParameters['person_id'] ?? '');
          return FamilyTreeScreen(personId: personId);
        },
      ),
      GoRoute(
        path: '/person/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PersonDetailScreen(personId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.relationship,
        builder: (context, state) => const RelationshipScreen(),
      ),

      // Search
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      // About/Info
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),

      // Partuturan Guide
      GoRoute(
        path: AppRoutes.partuturanGuide,
        builder: (context, state) => const PartuturanGuideScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authState != null;

      // 1. Prevent redirect loops - critical fix
      final isInitializing = state.matchedLocation == '/';
      final isGoingToHome = state.matchedLocation == AppRoutes.home;

      // 2. Skip unnecessary redirects
      if (loggedIn && isGoingToHome) {
        return null; // Already going to home, don't redirect
      }

      // 3. Handle initial route with auth check
      if (isInitializing) {
        return loggedIn ? AppRoutes.home : AppRoutes.login;
      }

      // 4. Authentication protection
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!loggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (loggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      // 5. No redirection needed for other routes
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Halaman Tidak Ditemukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman "${state.uri.path}" tidak tersedia.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go(AppRoutes.home),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
});
