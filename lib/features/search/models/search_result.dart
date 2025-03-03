import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required int id,
    required String firstName,
    required String lastName,
    required String gender,
    String? marga,
    DateTime? birthDate,
    String? photoUrl,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  // Computed properties
  const SearchResult._();

  String get fullName => '$firstName $lastName';
}
