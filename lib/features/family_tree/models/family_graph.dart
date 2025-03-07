import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_graph.freezed.dart';
part 'family_graph.g.dart';

@freezed
class FamilyGraph with _$FamilyGraph {
  const factory FamilyGraph({
    required List<GraphNode> nodes,
    required List<GraphEdge> edges,
    required int centralPersonId,
  }) = _FamilyGraph;

  factory FamilyGraph.fromJson(Map<String, dynamic> json) =>
      _$FamilyGraphFromJson(json);
}

@freezed
class GraphNode with _$GraphNode {
  const factory GraphNode({
    required int id,
    required String label,
    required GraphNodeData data,
  }) = _GraphNode;

  factory GraphNode.fromJson(Map<String, dynamic> json) =>
      _$GraphNodeFromJson(json);
}

@freezed
class GraphNodeData with _$GraphNodeData {
  const factory GraphNodeData({
    required String fullName,
    required String gender,
    required String marga,
    @Default(false) bool isCentral,
  }) = _GraphNodeData;

  factory GraphNodeData.fromJson(Map<String, dynamic> json) =>
      _$GraphNodeDataFromJson(json);
}

@freezed
class GraphEdge with _$GraphEdge {
  const factory GraphEdge({
    required int source,
    required int target,
    required String label,
    required GraphEdgeData data,
  }) = _GraphEdge;

  factory GraphEdge.fromJson(Map<String, dynamic> json) =>
      _$GraphEdgeFromJson(json);
}

@freezed
class GraphEdgeData with _$GraphEdgeData {
  const factory GraphEdgeData({
    required String relationshipType,
    DateTime? marriageDate,
    DateTime? divorceDate,
    bool? isCurrentMarriage,
    String? marriageLocation,
  }) = _GraphEdgeData;

  factory GraphEdgeData.fromJson(Map<String, dynamic> json) =>
      _$GraphEdgeDataFromJson(json);
}
