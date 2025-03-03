import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/core/api/api_client.dart';
import 'package:tarombo/core/api/api_exceptions.dart';
import 'package:tarombo/core/services/storage_service.dart';
import 'package:tarombo/features/auth/models/user.dart';
import 'package:tarombo/config/constants.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(apiClient, storageService);
});

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    final token = await _storageService.getAuthToken();
    if (token == null) return null;

    try {
      final response = await _apiClient.get(AppConstants.userProfileEndpoint);
      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data']['user'];
        final personData = response.data['data']['person'];

        // Save user ID and person ID to storage
        await _storageService.setUserId(userData['id']);
        if (personData != null) {
          await _storageService.setPersonId(personData['id']);
        }

        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          personId: personData != null ? personData['id'] : null,
        );
      }
      return null;
    } catch (e) {
      // If there's an error (like token expired), clear auth token
      await _storageService.clearAuthToken();
      return null;
    }
  }

  // Login method
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data']['user'];
        final token = response.data['data']['access_token'];

        // Save authentication token
        await _storageService.setAuthToken(token);
        await _storageService.setUserId(userData['id']);
        if (userData['person_id'] != null) {
          await _storageService.setPersonId(userData['person_id']);
        }

        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          personId: userData['person_id'],
        );
      } else {
        throw ApiException(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Register method
  Future<User> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      final response = await _apiClient.post(
        AppConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data']['user'];
        final token = response.data['data']['access_token'];

        // Save authentication token
        await _storageService.setAuthToken(token);
        await _storageService.setUserId(userData['id']);
        if (userData['person_id'] != null) {
          await _storageService.setPersonId(userData['person_id']);
        }

        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          personId: userData['person_id'],
        );
      } else {
        throw ApiException(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _apiClient.post(
        '/logout',
      );
    } catch (e) {
      // Even if logout API fails, clear local storage
    } finally {
      await _storageService.clearAll();
    }
  }

  // Link person record to user account
  Future<bool> linkPersonRecord(int personId) async {
    try {
      final response = await _apiClient.post(
        '/user/link-person',
        data: {
          'person_id': personId,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        await _storageService.setPersonId(personId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  updateProfile(String name) {}

  changePassword(
      String currentPassword, String newPassword, String confirmPassword) {}
}
