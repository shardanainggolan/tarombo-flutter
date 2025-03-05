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
        isCentral: false, // Will be set later based on central_person_id
      ),
    );
  }

  // Convert relationship to edge
  static GraphEdge relationshipToEdge(Map<String, dynamic> json) {
    return GraphEdge(
      source: json['from'] ?? 0,
      target: json['to'] ?? 0,
      label: json['type']?.toString() ?? '',
      data: GraphEdgeData(
        relationshipType: json['type']?.toString() ?? 'unknown',
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
