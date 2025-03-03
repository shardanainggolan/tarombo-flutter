// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      margaId: (json['margaId'] as num?)?.toInt(),
      margaName: json['margaName'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      deathDate: json['deathDate'] == null
          ? null
          : DateTime.parse(json['deathDate'] as String),
      photoUrl: json['photoUrl'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'margaId': instance.margaId,
      'margaName': instance.margaName,
      'birthDate': instance.birthDate?.toIso8601String(),
      'deathDate': instance.deathDate?.toIso8601String(),
      'photoUrl': instance.photoUrl,
      'notes': instance.notes,
    };
