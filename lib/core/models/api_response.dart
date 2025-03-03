import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    String? message,
    T? data,
    Map<String, dynamic>? meta,
    Map<String, dynamic>? errors,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return _$ApiResponseFromJson<T>(json, fromJsonT);
  }
}
