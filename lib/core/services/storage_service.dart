import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Provider should be overridden in main.dart');
});

class StorageService {
  late SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();

  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _personIdKey = 'person_id';
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';

  // Initialize service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Authentication token methods
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }

  // User ID methods
  Future<void> setUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  // Person ID methods
  Future<void> setPersonId(int? personId) async {
    if (personId != null) {
      await _prefs.setInt(_personIdKey, personId);
    } else {
      await _prefs.remove(_personIdKey);
    }
  }

  int? getPersonId() {
    return _prefs.getInt(_personIdKey);
  }

  // Theme settings
  Future<void> setThemeMode(String themeMode) async {
    await _prefs.setString(_themeKey, themeMode);
  }

  String getThemeMode() {
    return _prefs.getString(_themeKey) ?? 'system';
  }

  // Language settings
  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'id';
  }

  // Clear all data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
