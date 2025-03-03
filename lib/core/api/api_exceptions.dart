class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class TimeoutException extends ApiException {
  TimeoutException([super.message = 'Connection timed out. Please try again.']);
}

class NetworkException extends ApiException {
  NetworkException(
      [super.message = 'No internet connection. Please check your network.']);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(
      [super.message = 'Session expired. Please login again.']);
}

class BadRequestException extends ApiException {
  BadRequestException([super.message = 'Invalid request.']);
}

class ForbiddenException extends ApiException {
  ForbiddenException(
      [super.message = 'You do not have permission to access this resource.']);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'The requested resource was not found.']);
}

class ServerException extends ApiException {
  ServerException(
      [super.message = 'Server error occurred. Please try again later.']);
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;

  ValidationException(this.errors, [String message = 'Validation failed.'])
      : super(message);
}

class UnknownException extends ApiException {
  UnknownException(
      [super.message = 'An unexpected error occurred. Please try again.']);
}
