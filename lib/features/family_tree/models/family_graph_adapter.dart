import 'package:tarombo/features/family_tree/models/family_graph.dart';

class FamilyGraphAdapter {
  // Safe node conversion with null handling
  static GraphNode nodeFromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] ?? {};

    return GraphNode(
      id: json['id'] ?? 0,
      label: json['label']?.toString() ?? 'Unknown',
      data: GraphNodeData(
        fullName: dataJson['fullName']?.toString() ?? 'Unknown',
        gender: dataJson['gender']?.toString() ?? 'unknown',
        marga: dataJson['marga']?.toString() ?? '',
        isCentral: dataJson['isCentral'] ?? false,
      ),
    );
  }

  // Safe edge conversion with null handling
  static GraphEdge edgeFromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] ?? {};

    return GraphEdge(
      source: json['source'] ?? 0,
      target: json['target'] ?? 0,
      label: json['label']?.toString() ?? '',
      data: GraphEdgeData(
        relationshipType: dataJson['relationshipType']?.toString() ?? 'unknown',
      ),
    );
  }
}
