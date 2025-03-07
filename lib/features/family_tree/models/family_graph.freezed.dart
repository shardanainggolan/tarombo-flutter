// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FamilyGraph _$FamilyGraphFromJson(Map<String, dynamic> json) {
  return _FamilyGraph.fromJson(json);
}

/// @nodoc
mixin _$FamilyGraph {
  List<GraphNode> get nodes => throw _privateConstructorUsedError;
  List<GraphEdge> get edges => throw _privateConstructorUsedError;
  int get centralPersonId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FamilyGraphCopyWith<FamilyGraph> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyGraphCopyWith<$Res> {
  factory $FamilyGraphCopyWith(
          FamilyGraph value, $Res Function(FamilyGraph) then) =
      _$FamilyGraphCopyWithImpl<$Res, FamilyGraph>;
  @useResult
  $Res call(
      {List<GraphNode> nodes, List<GraphEdge> edges, int centralPersonId});
}

/// @nodoc
class _$FamilyGraphCopyWithImpl<$Res, $Val extends FamilyGraph>
    implements $FamilyGraphCopyWith<$Res> {
  _$FamilyGraphCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? centralPersonId = null,
  }) {
    return _then(_value.copyWith(
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<GraphNode>,
      edges: null == edges
          ? _value.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<GraphEdge>,
      centralPersonId: null == centralPersonId
          ? _value.centralPersonId
          : centralPersonId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyGraphImplCopyWith<$Res>
    implements $FamilyGraphCopyWith<$Res> {
  factory _$$FamilyGraphImplCopyWith(
          _$FamilyGraphImpl value, $Res Function(_$FamilyGraphImpl) then) =
      __$$FamilyGraphImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GraphNode> nodes, List<GraphEdge> edges, int centralPersonId});
}

/// @nodoc
class __$$FamilyGraphImplCopyWithImpl<$Res>
    extends _$FamilyGraphCopyWithImpl<$Res, _$FamilyGraphImpl>
    implements _$$FamilyGraphImplCopyWith<$Res> {
  __$$FamilyGraphImplCopyWithImpl(
      _$FamilyGraphImpl _value, $Res Function(_$FamilyGraphImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? centralPersonId = null,
  }) {
    return _then(_$FamilyGraphImpl(
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<GraphNode>,
      edges: null == edges
          ? _value._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<GraphEdge>,
      centralPersonId: null == centralPersonId
          ? _value.centralPersonId
          : centralPersonId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyGraphImpl implements _FamilyGraph {
  const _$FamilyGraphImpl(
      {required final List<GraphNode> nodes,
      required final List<GraphEdge> edges,
      required this.centralPersonId})
      : _nodes = nodes,
        _edges = edges;

  factory _$FamilyGraphImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyGraphImplFromJson(json);

  final List<GraphNode> _nodes;
  @override
  List<GraphNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<GraphEdge> _edges;
  @override
  List<GraphEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  final int centralPersonId;

  @override
  String toString() {
    return 'FamilyGraph(nodes: $nodes, edges: $edges, centralPersonId: $centralPersonId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyGraphImpl &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges) &&
            (identical(other.centralPersonId, centralPersonId) ||
                other.centralPersonId == centralPersonId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges),
      centralPersonId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyGraphImplCopyWith<_$FamilyGraphImpl> get copyWith =>
      __$$FamilyGraphImplCopyWithImpl<_$FamilyGraphImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyGraphImplToJson(
      this,
    );
  }
}

abstract class _FamilyGraph implements FamilyGraph {
  const factory _FamilyGraph(
      {required final List<GraphNode> nodes,
      required final List<GraphEdge> edges,
      required final int centralPersonId}) = _$FamilyGraphImpl;

  factory _FamilyGraph.fromJson(Map<String, dynamic> json) =
      _$FamilyGraphImpl.fromJson;

  @override
  List<GraphNode> get nodes;
  @override
  List<GraphEdge> get edges;
  @override
  int get centralPersonId;
  @override
  @JsonKey(ignore: true)
  _$$FamilyGraphImplCopyWith<_$FamilyGraphImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphNode _$GraphNodeFromJson(Map<String, dynamic> json) {
  return _GraphNode.fromJson(json);
}

/// @nodoc
mixin _$GraphNode {
  int get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  GraphNodeData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphNodeCopyWith<GraphNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphNodeCopyWith<$Res> {
  factory $GraphNodeCopyWith(GraphNode value, $Res Function(GraphNode) then) =
      _$GraphNodeCopyWithImpl<$Res, GraphNode>;
  @useResult
  $Res call({int id, String label, GraphNodeData data});

  $GraphNodeDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GraphNodeCopyWithImpl<$Res, $Val extends GraphNode>
    implements $GraphNodeCopyWith<$Res> {
  _$GraphNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphNodeData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GraphNodeDataCopyWith<$Res> get data {
    return $GraphNodeDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GraphNodeImplCopyWith<$Res>
    implements $GraphNodeCopyWith<$Res> {
  factory _$$GraphNodeImplCopyWith(
          _$GraphNodeImpl value, $Res Function(_$GraphNodeImpl) then) =
      __$$GraphNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String label, GraphNodeData data});

  @override
  $GraphNodeDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GraphNodeImplCopyWithImpl<$Res>
    extends _$GraphNodeCopyWithImpl<$Res, _$GraphNodeImpl>
    implements _$$GraphNodeImplCopyWith<$Res> {
  __$$GraphNodeImplCopyWithImpl(
      _$GraphNodeImpl _value, $Res Function(_$GraphNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? data = null,
  }) {
    return _then(_$GraphNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphNodeData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphNodeImpl implements _GraphNode {
  const _$GraphNodeImpl(
      {required this.id, required this.label, required this.data});

  factory _$GraphNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphNodeImplFromJson(json);

  @override
  final int id;
  @override
  final String label;
  @override
  final GraphNodeData data;

  @override
  String toString() {
    return 'GraphNode(id: $id, label: $label, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphNodeImplCopyWith<_$GraphNodeImpl> get copyWith =>
      __$$GraphNodeImplCopyWithImpl<_$GraphNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphNodeImplToJson(
      this,
    );
  }
}

abstract class _GraphNode implements GraphNode {
  const factory _GraphNode(
      {required final int id,
      required final String label,
      required final GraphNodeData data}) = _$GraphNodeImpl;

  factory _GraphNode.fromJson(Map<String, dynamic> json) =
      _$GraphNodeImpl.fromJson;

  @override
  int get id;
  @override
  String get label;
  @override
  GraphNodeData get data;
  @override
  @JsonKey(ignore: true)
  _$$GraphNodeImplCopyWith<_$GraphNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphNodeData _$GraphNodeDataFromJson(Map<String, dynamic> json) {
  return _GraphNodeData.fromJson(json);
}

/// @nodoc
mixin _$GraphNodeData {
  String get fullName => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get marga => throw _privateConstructorUsedError;
  bool get isCentral => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphNodeDataCopyWith<GraphNodeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphNodeDataCopyWith<$Res> {
  factory $GraphNodeDataCopyWith(
          GraphNodeData value, $Res Function(GraphNodeData) then) =
      _$GraphNodeDataCopyWithImpl<$Res, GraphNodeData>;
  @useResult
  $Res call({String fullName, String gender, String marga, bool isCentral});
}

/// @nodoc
class _$GraphNodeDataCopyWithImpl<$Res, $Val extends GraphNodeData>
    implements $GraphNodeDataCopyWith<$Res> {
  _$GraphNodeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? gender = null,
    Object? marga = null,
    Object? isCentral = null,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      marga: null == marga
          ? _value.marga
          : marga // ignore: cast_nullable_to_non_nullable
              as String,
      isCentral: null == isCentral
          ? _value.isCentral
          : isCentral // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphNodeDataImplCopyWith<$Res>
    implements $GraphNodeDataCopyWith<$Res> {
  factory _$$GraphNodeDataImplCopyWith(
          _$GraphNodeDataImpl value, $Res Function(_$GraphNodeDataImpl) then) =
      __$$GraphNodeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fullName, String gender, String marga, bool isCentral});
}

/// @nodoc
class __$$GraphNodeDataImplCopyWithImpl<$Res>
    extends _$GraphNodeDataCopyWithImpl<$Res, _$GraphNodeDataImpl>
    implements _$$GraphNodeDataImplCopyWith<$Res> {
  __$$GraphNodeDataImplCopyWithImpl(
      _$GraphNodeDataImpl _value, $Res Function(_$GraphNodeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? gender = null,
    Object? marga = null,
    Object? isCentral = null,
  }) {
    return _then(_$GraphNodeDataImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      marga: null == marga
          ? _value.marga
          : marga // ignore: cast_nullable_to_non_nullable
              as String,
      isCentral: null == isCentral
          ? _value.isCentral
          : isCentral // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphNodeDataImpl implements _GraphNodeData {
  const _$GraphNodeDataImpl(
      {required this.fullName,
      required this.gender,
      required this.marga,
      this.isCentral = false});

  factory _$GraphNodeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphNodeDataImplFromJson(json);

  @override
  final String fullName;
  @override
  final String gender;
  @override
  final String marga;
  @override
  @JsonKey()
  final bool isCentral;

  @override
  String toString() {
    return 'GraphNodeData(fullName: $fullName, gender: $gender, marga: $marga, isCentral: $isCentral)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphNodeDataImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.marga, marga) || other.marga == marga) &&
            (identical(other.isCentral, isCentral) ||
                other.isCentral == isCentral));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fullName, gender, marga, isCentral);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphNodeDataImplCopyWith<_$GraphNodeDataImpl> get copyWith =>
      __$$GraphNodeDataImplCopyWithImpl<_$GraphNodeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphNodeDataImplToJson(
      this,
    );
  }
}

abstract class _GraphNodeData implements GraphNodeData {
  const factory _GraphNodeData(
      {required final String fullName,
      required final String gender,
      required final String marga,
      final bool isCentral}) = _$GraphNodeDataImpl;

  factory _GraphNodeData.fromJson(Map<String, dynamic> json) =
      _$GraphNodeDataImpl.fromJson;

  @override
  String get fullName;
  @override
  String get gender;
  @override
  String get marga;
  @override
  bool get isCentral;
  @override
  @JsonKey(ignore: true)
  _$$GraphNodeDataImplCopyWith<_$GraphNodeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphEdge _$GraphEdgeFromJson(Map<String, dynamic> json) {
  return _GraphEdge.fromJson(json);
}

/// @nodoc
mixin _$GraphEdge {
  int get source => throw _privateConstructorUsedError;
  int get target => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  GraphEdgeData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphEdgeCopyWith<GraphEdge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphEdgeCopyWith<$Res> {
  factory $GraphEdgeCopyWith(GraphEdge value, $Res Function(GraphEdge) then) =
      _$GraphEdgeCopyWithImpl<$Res, GraphEdge>;
  @useResult
  $Res call({int source, int target, String label, GraphEdgeData data});

  $GraphEdgeDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GraphEdgeCopyWithImpl<$Res, $Val extends GraphEdge>
    implements $GraphEdgeCopyWith<$Res> {
  _$GraphEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? target = null,
    Object? label = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphEdgeData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GraphEdgeDataCopyWith<$Res> get data {
    return $GraphEdgeDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GraphEdgeImplCopyWith<$Res>
    implements $GraphEdgeCopyWith<$Res> {
  factory _$$GraphEdgeImplCopyWith(
          _$GraphEdgeImpl value, $Res Function(_$GraphEdgeImpl) then) =
      __$$GraphEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int source, int target, String label, GraphEdgeData data});

  @override
  $GraphEdgeDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GraphEdgeImplCopyWithImpl<$Res>
    extends _$GraphEdgeCopyWithImpl<$Res, _$GraphEdgeImpl>
    implements _$$GraphEdgeImplCopyWith<$Res> {
  __$$GraphEdgeImplCopyWithImpl(
      _$GraphEdgeImpl _value, $Res Function(_$GraphEdgeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? target = null,
    Object? label = null,
    Object? data = null,
  }) {
    return _then(_$GraphEdgeImpl(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphEdgeData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphEdgeImpl implements _GraphEdge {
  const _$GraphEdgeImpl(
      {required this.source,
      required this.target,
      required this.label,
      required this.data});

  factory _$GraphEdgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphEdgeImplFromJson(json);

  @override
  final int source;
  @override
  final int target;
  @override
  final String label;
  @override
  final GraphEdgeData data;

  @override
  String toString() {
    return 'GraphEdge(source: $source, target: $target, label: $label, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphEdgeImpl &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, source, target, label, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphEdgeImplCopyWith<_$GraphEdgeImpl> get copyWith =>
      __$$GraphEdgeImplCopyWithImpl<_$GraphEdgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphEdgeImplToJson(
      this,
    );
  }
}

abstract class _GraphEdge implements GraphEdge {
  const factory _GraphEdge(
      {required final int source,
      required final int target,
      required final String label,
      required final GraphEdgeData data}) = _$GraphEdgeImpl;

  factory _GraphEdge.fromJson(Map<String, dynamic> json) =
      _$GraphEdgeImpl.fromJson;

  @override
  int get source;
  @override
  int get target;
  @override
  String get label;
  @override
  GraphEdgeData get data;
  @override
  @JsonKey(ignore: true)
  _$$GraphEdgeImplCopyWith<_$GraphEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphEdgeData _$GraphEdgeDataFromJson(Map<String, dynamic> json) {
  return _GraphEdgeData.fromJson(json);
}

/// @nodoc
mixin _$GraphEdgeData {
  String get relationshipType => throw _privateConstructorUsedError;
  DateTime? get marriageDate => throw _privateConstructorUsedError;
  DateTime? get divorceDate => throw _privateConstructorUsedError;
  bool? get isCurrentMarriage => throw _privateConstructorUsedError;
  String? get marriageLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphEdgeDataCopyWith<GraphEdgeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphEdgeDataCopyWith<$Res> {
  factory $GraphEdgeDataCopyWith(
          GraphEdgeData value, $Res Function(GraphEdgeData) then) =
      _$GraphEdgeDataCopyWithImpl<$Res, GraphEdgeData>;
  @useResult
  $Res call(
      {String relationshipType,
      DateTime? marriageDate,
      DateTime? divorceDate,
      bool? isCurrentMarriage,
      String? marriageLocation});
}

/// @nodoc
class _$GraphEdgeDataCopyWithImpl<$Res, $Val extends GraphEdgeData>
    implements $GraphEdgeDataCopyWith<$Res> {
  _$GraphEdgeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationshipType = null,
    Object? marriageDate = freezed,
    Object? divorceDate = freezed,
    Object? isCurrentMarriage = freezed,
    Object? marriageLocation = freezed,
  }) {
    return _then(_value.copyWith(
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      marriageDate: freezed == marriageDate
          ? _value.marriageDate
          : marriageDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      divorceDate: freezed == divorceDate
          ? _value.divorceDate
          : divorceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrentMarriage: freezed == isCurrentMarriage
          ? _value.isCurrentMarriage
          : isCurrentMarriage // ignore: cast_nullable_to_non_nullable
              as bool?,
      marriageLocation: freezed == marriageLocation
          ? _value.marriageLocation
          : marriageLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphEdgeDataImplCopyWith<$Res>
    implements $GraphEdgeDataCopyWith<$Res> {
  factory _$$GraphEdgeDataImplCopyWith(
          _$GraphEdgeDataImpl value, $Res Function(_$GraphEdgeDataImpl) then) =
      __$$GraphEdgeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String relationshipType,
      DateTime? marriageDate,
      DateTime? divorceDate,
      bool? isCurrentMarriage,
      String? marriageLocation});
}

/// @nodoc
class __$$GraphEdgeDataImplCopyWithImpl<$Res>
    extends _$GraphEdgeDataCopyWithImpl<$Res, _$GraphEdgeDataImpl>
    implements _$$GraphEdgeDataImplCopyWith<$Res> {
  __$$GraphEdgeDataImplCopyWithImpl(
      _$GraphEdgeDataImpl _value, $Res Function(_$GraphEdgeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationshipType = null,
    Object? marriageDate = freezed,
    Object? divorceDate = freezed,
    Object? isCurrentMarriage = freezed,
    Object? marriageLocation = freezed,
  }) {
    return _then(_$GraphEdgeDataImpl(
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      marriageDate: freezed == marriageDate
          ? _value.marriageDate
          : marriageDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      divorceDate: freezed == divorceDate
          ? _value.divorceDate
          : divorceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrentMarriage: freezed == isCurrentMarriage
          ? _value.isCurrentMarriage
          : isCurrentMarriage // ignore: cast_nullable_to_non_nullable
              as bool?,
      marriageLocation: freezed == marriageLocation
          ? _value.marriageLocation
          : marriageLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphEdgeDataImpl implements _GraphEdgeData {
  const _$GraphEdgeDataImpl(
      {required this.relationshipType,
      this.marriageDate,
      this.divorceDate,
      this.isCurrentMarriage,
      this.marriageLocation});

  factory _$GraphEdgeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphEdgeDataImplFromJson(json);

  @override
  final String relationshipType;
  @override
  final DateTime? marriageDate;
  @override
  final DateTime? divorceDate;
  @override
  final bool? isCurrentMarriage;
  @override
  final String? marriageLocation;

  @override
  String toString() {
    return 'GraphEdgeData(relationshipType: $relationshipType, marriageDate: $marriageDate, divorceDate: $divorceDate, isCurrentMarriage: $isCurrentMarriage, marriageLocation: $marriageLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphEdgeDataImpl &&
            (identical(other.relationshipType, relationshipType) ||
                other.relationshipType == relationshipType) &&
            (identical(other.marriageDate, marriageDate) ||
                other.marriageDate == marriageDate) &&
            (identical(other.divorceDate, divorceDate) ||
                other.divorceDate == divorceDate) &&
            (identical(other.isCurrentMarriage, isCurrentMarriage) ||
                other.isCurrentMarriage == isCurrentMarriage) &&
            (identical(other.marriageLocation, marriageLocation) ||
                other.marriageLocation == marriageLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, relationshipType, marriageDate,
      divorceDate, isCurrentMarriage, marriageLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphEdgeDataImplCopyWith<_$GraphEdgeDataImpl> get copyWith =>
      __$$GraphEdgeDataImplCopyWithImpl<_$GraphEdgeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphEdgeDataImplToJson(
      this,
    );
  }
}

abstract class _GraphEdgeData implements GraphEdgeData {
  const factory _GraphEdgeData(
      {required final String relationshipType,
      final DateTime? marriageDate,
      final DateTime? divorceDate,
      final bool? isCurrentMarriage,
      final String? marriageLocation}) = _$GraphEdgeDataImpl;

  factory _GraphEdgeData.fromJson(Map<String, dynamic> json) =
      _$GraphEdgeDataImpl.fromJson;

  @override
  String get relationshipType;
  @override
  DateTime? get marriageDate;
  @override
  DateTime? get divorceDate;
  @override
  bool? get isCurrentMarriage;
  @override
  String? get marriageLocation;
  @override
  @JsonKey(ignore: true)
  _$$GraphEdgeDataImplCopyWith<_$GraphEdgeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
