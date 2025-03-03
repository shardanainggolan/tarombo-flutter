import 'package:dio/dio.dart';
import 'package:tarombo/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.getAuthToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token expiration (401 errors)
    if (err.response?.statusCode == 401) {
      // You could trigger a logout event here
    }
    handler.next(err);
  }
}
