import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required int id,
    required String firstName,
    required String lastName,
    required String gender,
    int? margaId,
    String? margaName,
    DateTime? birthDate,
    DateTime? deathDate,
    String? photoUrl,
    String? notes,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  // Computed properties
  const Person._();

  String get fullName => '$firstName $lastName';
  bool get isLiving => deathDate == null;
  String get displayName =>
      '$firstName $lastName${margaName != null ? ' ($margaName)' : ''}';
}
