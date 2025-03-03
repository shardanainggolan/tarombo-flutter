import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/auth/models/user.dart';
import 'package:tarombo/features/auth/repositories/auth_repository.dart';

// Provider to track authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(null) {
    // Check if user is already logged in
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = user;
    } catch (e) {
      state = null;
    }
  }

  // Check login status
  Future<void> checkLoginStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = user;
    } catch (e) {
      // If there's an error, assume user is not logged in
      state = null;
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      final user = await _authRepository.login(email, password);
      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Register method
  Future<bool> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      final user = await _authRepository.register(
          name, email, password, passwordConfirmation);
      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _authRepository.logout();
    state = null;
  }

  // Link user account to person record
  Future<bool> linkPersonRecord(int personId) async {
    try {
      final success = await _authRepository.linkPersonRecord(personId);
      if (success && state != null) {
        state = state!.copyWith(personId: personId);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile(String name) async {
    try {
      final user = await _authRepository.updateProfile(name);
      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      final success = await _authRepository.changePassword(
        currentPassword,
        newPassword,
        confirmPassword,
      );
      return success;
    } catch (e) {
      return false;
    }
  }
}
