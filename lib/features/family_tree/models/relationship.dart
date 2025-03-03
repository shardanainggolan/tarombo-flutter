import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tarombo/features/family_tree/models/person.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

@freezed
class Relationship with _$Relationship {
  const factory Relationship({
    required PersonBasic fromPerson,
    required PersonBasic toPerson,
    String? term,
    String? category,
    String? description,
    String? relationshipPath,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}

@freezed
class PersonBasic with _$PersonBasic {
  const factory PersonBasic({
    required int id,
    required String name,
    required String gender,
    required String marga,
  }) = _PersonBasic;

  factory PersonBasic.fromJson(Map<String, dynamic> json) =>
      _$PersonBasicFromJson(json);
}
