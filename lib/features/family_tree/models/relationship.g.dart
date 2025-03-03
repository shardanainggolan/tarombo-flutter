// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipImpl _$$RelationshipImplFromJson(Map<String, dynamic> json) =>
    _$RelationshipImpl(
      fromPerson:
          PersonBasic.fromJson(json['fromPerson'] as Map<String, dynamic>),
      toPerson: PersonBasic.fromJson(json['toPerson'] as Map<String, dynamic>),
      term: json['term'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      relationshipPath: json['relationshipPath'] as String?,
    );

Map<String, dynamic> _$$RelationshipImplToJson(_$RelationshipImpl instance) =>
    <String, dynamic>{
      'fromPerson': instance.fromPerson,
      'toPerson': instance.toPerson,
      'term': instance.term,
      'category': instance.category,
      'description': instance.description,
      'relationshipPath': instance.relationshipPath,
    };

_$PersonBasicImpl _$$PersonBasicImplFromJson(Map<String, dynamic> json) =>
    _$PersonBasicImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      gender: json['gender'] as String,
      marga: json['marga'] as String,
    );

Map<String, dynamic> _$$PersonBasicImplToJson(_$PersonBasicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'marga': instance.marga,
    };
