// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Relationship _$RelationshipFromJson(Map<String, dynamic> json) {
  return _Relationship.fromJson(json);
}

/// @nodoc
mixin _$Relationship {
  PersonBasic get fromPerson => throw _privateConstructorUsedError;
  PersonBasic get toPerson => throw _privateConstructorUsedError;
  String? get term => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get relationshipPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelationshipCopyWith<Relationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipCopyWith<$Res> {
  factory $RelationshipCopyWith(
          Relationship value, $Res Function(Relationship) then) =
      _$RelationshipCopyWithImpl<$Res, Relationship>;
  @useResult
  $Res call(
      {PersonBasic fromPerson,
      PersonBasic toPerson,
      String? term,
      String? category,
      String? description,
      String? relationshipPath});

  $PersonBasicCopyWith<$Res> get fromPerson;
  $PersonBasicCopyWith<$Res> get toPerson;
}

/// @nodoc
class _$RelationshipCopyWithImpl<$Res, $Val extends Relationship>
    implements $RelationshipCopyWith<$Res> {
  _$RelationshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromPerson = null,
    Object? toPerson = null,
    Object? term = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? relationshipPath = freezed,
  }) {
    return _then(_value.copyWith(
      fromPerson: null == fromPerson
          ? _value.fromPerson
          : fromPerson // ignore: cast_nullable_to_non_nullable
              as PersonBasic,
      toPerson: null == toPerson
          ? _value.toPerson
          : toPerson // ignore: cast_nullable_to_non_nullable
              as PersonBasic,
      term: freezed == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relationshipPath: freezed == relationshipPath
          ? _value.relationshipPath
          : relationshipPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonBasicCopyWith<$Res> get fromPerson {
    return $PersonBasicCopyWith<$Res>(_value.fromPerson, (value) {
      return _then(_value.copyWith(fromPerson: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonBasicCopyWith<$Res> get toPerson {
    return $PersonBasicCopyWith<$Res>(_value.toPerson, (value) {
      return _then(_value.copyWith(toPerson: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RelationshipImplCopyWith<$Res>
    implements $RelationshipCopyWith<$Res> {
  factory _$$RelationshipImplCopyWith(
          _$RelationshipImpl value, $Res Function(_$RelationshipImpl) then) =
      __$$RelationshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PersonBasic fromPerson,
      PersonBasic toPerson,
      String? term,
      String? category,
      String? description,
      String? relationshipPath});

  @override
  $PersonBasicCopyWith<$Res> get fromPerson;
  @override
  $PersonBasicCopyWith<$Res> get toPerson;
}

/// @nodoc
class __$$RelationshipImplCopyWithImpl<$Res>
    extends _$RelationshipCopyWithImpl<$Res, _$RelationshipImpl>
    implements _$$RelationshipImplCopyWith<$Res> {
  __$$RelationshipImplCopyWithImpl(
      _$RelationshipImpl _value, $Res Function(_$RelationshipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromPerson = null,
    Object? toPerson = null,
    Object? term = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? relationshipPath = freezed,
  }) {
    return _then(_$RelationshipImpl(
      fromPerson: null == fromPerson
          ? _value.fromPerson
          : fromPerson // ignore: cast_nullable_to_non_nullable
              as PersonBasic,
      toPerson: null == toPerson
          ? _value.toPerson
          : toPerson // ignore: cast_nullable_to_non_nullable
              as PersonBasic,
      term: freezed == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relationshipPath: freezed == relationshipPath
          ? _value.relationshipPath
          : relationshipPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipImpl implements _Relationship {
  const _$RelationshipImpl(
      {required this.fromPerson,
      required this.toPerson,
      this.term,
      this.category,
      this.description,
      this.relationshipPath});

  factory _$RelationshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipImplFromJson(json);

  @override
  final PersonBasic fromPerson;
  @override
  final PersonBasic toPerson;
  @override
  final String? term;
  @override
  final String? category;
  @override
  final String? description;
  @override
  final String? relationshipPath;

  @override
  String toString() {
    return 'Relationship(fromPerson: $fromPerson, toPerson: $toPerson, term: $term, category: $category, description: $description, relationshipPath: $relationshipPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipImpl &&
            (identical(other.fromPerson, fromPerson) ||
                other.fromPerson == fromPerson) &&
            (identical(other.toPerson, toPerson) ||
                other.toPerson == toPerson) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relationshipPath, relationshipPath) ||
                other.relationshipPath == relationshipPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fromPerson, toPerson, term,
      category, description, relationshipPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipImplCopyWith<_$RelationshipImpl> get copyWith =>
      __$$RelationshipImplCopyWithImpl<_$RelationshipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipImplToJson(
      this,
    );
  }
}

abstract class _Relationship implements Relationship {
  const factory _Relationship(
      {required final PersonBasic fromPerson,
      required final PersonBasic toPerson,
      final String? term,
      final String? category,
      final String? description,
      final String? relationshipPath}) = _$RelationshipImpl;

  factory _Relationship.fromJson(Map<String, dynamic> json) =
      _$RelationshipImpl.fromJson;

  @override
  PersonBasic get fromPerson;
  @override
  PersonBasic get toPerson;
  @override
  String? get term;
  @override
  String? get category;
  @override
  String? get description;
  @override
  String? get relationshipPath;
  @override
  @JsonKey(ignore: true)
  _$$RelationshipImplCopyWith<_$RelationshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonBasic _$PersonBasicFromJson(Map<String, dynamic> json) {
  return _PersonBasic.fromJson(json);
}

/// @nodoc
mixin _$PersonBasic {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get marga => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonBasicCopyWith<PersonBasic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonBasicCopyWith<$Res> {
  factory $PersonBasicCopyWith(
          PersonBasic value, $Res Function(PersonBasic) then) =
      _$PersonBasicCopyWithImpl<$Res, PersonBasic>;
  @useResult
  $Res call({int id, String name, String gender, String marga});
}

/// @nodoc
class _$PersonBasicCopyWithImpl<$Res, $Val extends PersonBasic>
    implements $PersonBasicCopyWith<$Res> {
  _$PersonBasicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gender = null,
    Object? marga = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      marga: null == marga
          ? _value.marga
          : marga // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonBasicImplCopyWith<$Res>
    implements $PersonBasicCopyWith<$Res> {
  factory _$$PersonBasicImplCopyWith(
          _$PersonBasicImpl value, $Res Function(_$PersonBasicImpl) then) =
      __$$PersonBasicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String gender, String marga});
}

/// @nodoc
class __$$PersonBasicImplCopyWithImpl<$Res>
    extends _$PersonBasicCopyWithImpl<$Res, _$PersonBasicImpl>
    implements _$$PersonBasicImplCopyWith<$Res> {
  __$$PersonBasicImplCopyWithImpl(
      _$PersonBasicImpl _value, $Res Function(_$PersonBasicImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gender = null,
    Object? marga = null,
  }) {
    return _then(_$PersonBasicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      marga: null == marga
          ? _value.marga
          : marga // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonBasicImpl implements _PersonBasic {
  const _$PersonBasicImpl(
      {required this.id,
      required this.name,
      required this.gender,
      required this.marga});

  factory _$PersonBasicImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonBasicImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String gender;
  @override
  final String marga;

  @override
  String toString() {
    return 'PersonBasic(id: $id, name: $name, gender: $gender, marga: $marga)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonBasicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.marga, marga) || other.marga == marga));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, gender, marga);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonBasicImplCopyWith<_$PersonBasicImpl> get copyWith =>
      __$$PersonBasicImplCopyWithImpl<_$PersonBasicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonBasicImplToJson(
      this,
    );
  }
}

abstract class _PersonBasic implements PersonBasic {
  const factory _PersonBasic(
      {required final int id,
      required final String name,
      required final String gender,
      required final String marga}) = _$PersonBasicImpl;

  factory _PersonBasic.fromJson(Map<String, dynamic> json) =
      _$PersonBasicImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get gender;
  @override
  String get marga;
  @override
  @JsonKey(ignore: true)
  _$$PersonBasicImplCopyWith<_$PersonBasicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
