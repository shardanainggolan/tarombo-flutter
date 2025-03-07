// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyGraphImpl _$$FamilyGraphImplFromJson(Map<String, dynamic> json) =>
    _$FamilyGraphImpl(
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => GraphNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>)
          .map((e) => GraphEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
      centralPersonId: (json['centralPersonId'] as num).toInt(),
    );

Map<String, dynamic> _$$FamilyGraphImplToJson(_$FamilyGraphImpl instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'edges': instance.edges,
      'centralPersonId': instance.centralPersonId,
    };

_$GraphNodeImpl _$$GraphNodeImplFromJson(Map<String, dynamic> json) =>
    _$GraphNodeImpl(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      data: GraphNodeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GraphNodeImplToJson(_$GraphNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'data': instance.data,
    };

_$GraphNodeDataImpl _$$GraphNodeDataImplFromJson(Map<String, dynamic> json) =>
    _$GraphNodeDataImpl(
      fullName: json['fullName'] as String,
      gender: json['gender'] as String,
      marga: json['marga'] as String,
      isCentral: json['isCentral'] as bool? ?? false,
    );

Map<String, dynamic> _$$GraphNodeDataImplToJson(_$GraphNodeDataImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'gender': instance.gender,
      'marga': instance.marga,
      'isCentral': instance.isCentral,
    };

_$GraphEdgeImpl _$$GraphEdgeImplFromJson(Map<String, dynamic> json) =>
    _$GraphEdgeImpl(
      source: (json['source'] as num).toInt(),
      target: (json['target'] as num).toInt(),
      label: json['label'] as String,
      data: GraphEdgeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GraphEdgeImplToJson(_$GraphEdgeImpl instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'label': instance.label,
      'data': instance.data,
    };

_$GraphEdgeDataImpl _$$GraphEdgeDataImplFromJson(Map<String, dynamic> json) =>
    _$GraphEdgeDataImpl(
      relationshipType: json['relationshipType'] as String,
      marriageDate: json['marriageDate'] == null
          ? null
          : DateTime.parse(json['marriageDate'] as String),
      divorceDate: json['divorceDate'] == null
          ? null
          : DateTime.parse(json['divorceDate'] as String),
      isCurrentMarriage: json['isCurrentMarriage'] as bool?,
      marriageLocation: json['marriageLocation'] as String?,
    );

Map<String, dynamic> _$$GraphEdgeDataImplToJson(_$GraphEdgeDataImpl instance) =>
    <String, dynamic>{
      'relationshipType': instance.relationshipType,
      'marriageDate': instance.marriageDate?.toIso8601String(),
      'divorceDate': instance.divorceDate?.toIso8601String(),
      'isCurrentMarriage': instance.isCurrentMarriage,
      'marriageLocation': instance.marriageLocation,
    };
