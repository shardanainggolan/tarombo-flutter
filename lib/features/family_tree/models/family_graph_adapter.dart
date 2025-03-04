import 'package:tarombo/features/family_tree/models/family_graph.dart';

class FamilyGraphAdapter {
  // Safe node conversion with null handling
  static GraphNode nodeFromJson(Map<String, dynamic> json) {
    return GraphNode(
      id: json['id'] ?? 0,
      label: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}",
      data: GraphNodeData(
        fullName: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}",
        gender: json['gender']?.toString() ?? 'unknown',
        marga: json['marga_name']?.toString() ?? '',
        isCentral: false, // Will be set based on central_person_id
      ),
    );
  }

  static GraphEdge relationshipToEdge(Map<String, dynamic> relationship) {
    return GraphEdge(
      source: relationship['from'] ?? 0,
      target: relationship['to'] ?? 0,
      label: relationship['type']?.toString() ?? '',
      data: GraphEdgeData(
        relationshipType: relationship['type']?.toString() ?? 'unknown',
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
