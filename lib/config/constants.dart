class AppConstants {
  // API Configuration
  // static const String apiBaseUrl = 'https://api.tarombo.com/api';
  static const String apiBaseUrl = 'http://192.168.215.80:8000/api';

  // Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String userProfileEndpoint = '/user/profile';
  static const String familyTreeEndpoint = '/family-tree';
  static const String familyGraphEndpoint = '/family-graph';
  static const String personEndpoint = '/people';
  static const String searchEndpoint = '/people/search';
  static const String relationshipEndpoint = '/partuturan/relationship';
  static const String allRelationshipsEndpoint =
      '/partuturan/all-relationships';

  // App settings
  static const int graphMaxGenerationsUp = 3;
  static const int graphMaxGenerationsDown = 3;

  // Error messages
  static const String networkErrorMessage = 'Periksa koneksi internet Anda';
  static const String serverErrorMessage = 'Terjadi kesalahan pada server';
  static const String genericErrorMessage =
      'Terjadi kesalahan. Silakan coba lagi';
}
