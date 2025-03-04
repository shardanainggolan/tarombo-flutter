import 'package:tarombo/features/family_tree/models/family_graph.dart';

class FamilyUnit {
  final GraphNode primaryPerson;
  final List<GraphNode> parents;
  final List<GraphNode> spouses;
  final List<GraphNode> children;

  FamilyUnit({
    required this.primaryPerson,
    this.parents = const [],
    required this.spouses,
    required this.children,
  });
}
