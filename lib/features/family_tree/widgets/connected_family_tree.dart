import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';

/// A connected family tree visualization that ensures proper hierarchical structure
class ConnectedFamilyTree extends ConsumerWidget {
  final FamilyGraph familyGraph;
  final TransformationController transformController;
  final int centralPersonId;

  const ConnectedFamilyTree({
    Key? key,
    required this.familyGraph,
    required this.transformController,
    required this.centralPersonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch relationship data for the central person
    final relationshipsAsync =
        ref.watch(allRelationshipsProvider(centralPersonId));

    // Get relationships data
    Map<int, String> relationshipTerms = {};
    if (relationshipsAsync.value != null) {
      for (final relationship in relationshipsAsync.value!) {
        final personId = relationship['person']?['id'] as int?;
        final term = relationship['term'] as String?;

        if (personId != null && term != null) {
          relationshipTerms[personId] = term;
        }
      }
    }

    // Build the complete family structure
    final Map<int, int> childToParent = _buildChildToParentMap(familyGraph);
    final Map<int, List<int>> parentToChildren =
        _buildParentToChildrenMap(familyGraph);
    final Map<int, List<int>> personToSpouses = _buildSpouseMap(familyGraph);

    // Find the top ancestor
    final topAncestorId = _findTopAncestor(centralPersonId, childToParent);

    // Organize family by generations
    final Map<int, List<GraphNode>> generationMap = _organizeByGenerations(
        familyGraph, childToParent, parentToChildren, topAncestorId);

    // Debug information
    print("Connected Family Tree: Top ancestor: $topAncestorId");
    print("Generations: ${generationMap.keys.toList()}");

    return InteractiveViewer(
      transformationController: transformController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 2.0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Render each generation in order
              for (int gen = generationMap.keys.reduce(math.min);
                  gen <= generationMap.keys.reduce(math.max);
                  gen++)
                if (generationMap.containsKey(gen))
                  _buildGenerationRow(
                    context,
                    gen,
                    generationMap[gen]!,
                    parentToChildren,
                    personToSpouses,
                    relationshipTerms,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a map of child to parent
  Map<int, int> _buildChildToParentMap(FamilyGraph familyGraph) {
    final Map<int, int> childToParent = {};

    for (final edge in familyGraph.edges) {
      if (edge.data.relationshipType == 'father' ||
          edge.data.relationshipType == 'mother') {
        childToParent[edge.target] = edge.source;
      }
    }

    return childToParent;
  }

  // Build a map of parent to children
  Map<int, List<int>> _buildParentToChildrenMap(FamilyGraph familyGraph) {
    final Map<int, List<int>> parentToChildren = {};

    for (final edge in familyGraph.edges) {
      if (edge.data.relationshipType == 'father' ||
          edge.data.relationshipType == 'mother') {
        parentToChildren.putIfAbsent(edge.source, () => []).add(edge.target);
      }
    }

    return parentToChildren;
  }

  // Build a map of person to spouses
  Map<int, List<int>> _buildSpouseMap(FamilyGraph familyGraph) {
    final Map<int, List<int>> personToSpouses = {};

    for (final edge in familyGraph.edges) {
      if (edge.data.relationshipType == 'spouse') {
        personToSpouses.putIfAbsent(edge.source, () => []).add(edge.target);
        personToSpouses.putIfAbsent(edge.target, () => []).add(edge.source);
      }
    }

    return personToSpouses;
  }

  // Find the top ancestor starting from a person
  int _findTopAncestor(int personId, Map<int, int> childToParent) {
    int currentId = personId;
    while (childToParent.containsKey(currentId)) {
      currentId = childToParent[currentId]!;
    }
    return currentId;
  }

  // Organize people by generations
  Map<int, List<GraphNode>> _organizeByGenerations(
      FamilyGraph familyGraph,
      Map<int, int> childToParent,
      Map<int, List<int>> parentToChildren,
      int topAncestorId) {
    // Map of generation number to list of people
    final Map<int, List<GraphNode>> generationMap = {};

    // Map of person ID to generation number
    final Map<int, int> personGenerations = {};

    // Create a map of ID to node for quick lookup
    final Map<int, GraphNode> idToNode = {};
    for (final node in familyGraph.nodes) {
      idToNode[node.id] = node;
    }

    // Start with top ancestor at generation 0
    personGenerations[topAncestorId] = 0;

    // Use breadth-first traversal to assign generations
    final List<int> queue = [topAncestorId];
    final Set<int> visited = {topAncestorId};

    while (queue.isNotEmpty) {
      final int currentId = queue.removeAt(0);
      final int currentGen = personGenerations[currentId]!;

      // Process children
      final List<int> children = parentToChildren[currentId] ?? [];
      for (final childId in children) {
        personGenerations[childId] = currentGen + 1;
        if (!visited.contains(childId)) {
          queue.add(childId);
          visited.add(childId);
        }
      }
    }

    // Group people by generation
    for (final entry in personGenerations.entries) {
      final personId = entry.key;
      final generation = entry.value;

      if (idToNode.containsKey(personId)) {
        generationMap
            .putIfAbsent(generation, () => [])
            .add(idToNode[personId]!);
      }
    }

    return generationMap;
  }

  // Build a row for a specific generation
  Widget _buildGenerationRow(
    BuildContext context,
    int generation,
    List<GraphNode> people,
    Map<int, List<int>> parentToChildren,
    Map<int, List<int>> personToSpouses,
    Map<int, String> relationshipTerms,
  ) {
    // Create a map of ID to node for quick lookup
    final Map<int, GraphNode> idToNode = {};
    for (final node in familyGraph.nodes) {
      idToNode[node.id] = node;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          // Generation label (can be removed in production)
          Text(
            "Generation $generation",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),

          // Family units in this generation
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              for (final person in people)
                // Skip if this person is a spouse of someone else in this generation
                // to avoid duplicate family units
                if (!_isSpouseOfProcessed(person.id, people, personToSpouses))
                  _buildFamilyUnit(
                    context,
                    person,
                    idToNode,
                    parentToChildren,
                    personToSpouses,
                    relationshipTerms,
                  ),
            ],
          ),
        ],
      ),
    );
  }

  // Check if a person is a spouse of another person who comes earlier in the list
  bool _isSpouseOfProcessed(
    int personId,
    List<GraphNode> peopleInGeneration,
    Map<int, List<int>> personToSpouses,
  ) {
    final spouseIds = personToSpouses[personId] ?? [];

    for (final node in peopleInGeneration) {
      // If this person comes before the current person and is their spouse
      if (node.id < personId && spouseIds.contains(node.id)) {
        return true;
      }
    }

    return false;
  }

  // Build a complete family unit (person, spouse, children)
  Widget _buildFamilyUnit(
    BuildContext context,
    GraphNode person,
    Map<int, GraphNode> idToNode,
    Map<int, List<int>> parentToChildren,
    Map<int, List<int>> personToSpouses,
    Map<int, String> relationshipTerms,
  ) {
    final List<int> childIds = parentToChildren[person.id] ?? [];
    final List<int> spouseIds = personToSpouses[person.id] ?? [];

    // Only show spouse nodes that exist
    final List<GraphNode> spouseNodes = [];
    for (final id in spouseIds) {
      if (idToNode.containsKey(id)) {
        spouseNodes.add(idToNode[id]!);
      }
    }

    // Only show child nodes that exist
    final List<GraphNode> childNodes = [];
    for (final id in childIds) {
      if (idToNode.containsKey(id)) {
        childNodes.add(idToNode[id]!);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Person and spouse row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary person
            _buildPersonNode(
              context,
              person,
              person.id == centralPersonId,
              relationshipTerms,
            ),

            // Spouse (showing only the first spouse for simplicity)
            if (spouseNodes.isNotEmpty) ...[
              Container(
                width: 40,
                height: 2,
                color: Colors.red,
              ),
              _buildPersonNode(
                context,
                spouseNodes.first,
                spouseNodes.first.id == centralPersonId,
                relationshipTerms,
              ),
            ],
          ],
        ),

        // Children section (only show if this person has children)
        if (childNodes.isNotEmpty) ...[
          // Vertical connector from parents to children
          Container(
            width: 2,
            height: 30,
            color: Colors.black,
          ),

          // Children with connectors
          _buildChildrenWithConnectors(context, childNodes, relationshipTerms),
        ],
      ],
    );
  }

  // Build children with proper connectors
  Widget _buildChildrenWithConnectors(
    BuildContext context,
    List<GraphNode> children,
    Map<int, String> relationshipTerms,
  ) {
    // For a single child, no need for horizontal connectors
    if (children.length == 1) {
      return _buildPersonNode(
        context,
        children.first,
        children.first.id == centralPersonId,
        relationshipTerms,
      );
    }

    // For multiple children, create a container with connecting lines
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Horizontal connector to span all children
        Container(
          width: (children.length * 130.0) - 40,
          height: 2,
          color: Colors.black,
        ),

        // Row of children with vertical connectors
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final child in children)
              Container(
                width: 130.0,
                child: Column(
                  children: [
                    // Vertical connector to child
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.black,
                    ),
                    // Child node
                    _buildPersonNode(
                      context,
                      child,
                      child.id == centralPersonId,
                      relationshipTerms,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Build a single person node
  Widget _buildPersonNode(
    BuildContext context,
    GraphNode node,
    bool isCentral,
    Map<int, String> relationshipTerms,
  ) {
    // Determine gender-based styling
    final gender = node.data.gender?.toLowerCase() ?? 'unknown';

    final Color nodeColor = gender == 'male'
        ? Colors.blue.shade100
        : (gender == 'female' ? Colors.pink.shade100 : Colors.grey.shade200);

    final Color borderColor = isCentral ? Colors.red : Colors.grey;

    // Get relationship term for this person
    final relationshipTerm = relationshipTerms[node.id];

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/person/${node.id}');
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: nodeColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: isCentral ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gender icon
            Icon(
              gender == 'male'
                  ? Icons.male
                  : (gender == 'female' ? Icons.female : Icons.person),
              color: gender == 'male'
                  ? Colors.blue.shade800
                  : (gender == 'female'
                      ? Colors.pink.shade800
                      : Colors.grey.shade800),
              size: 20,
            ),
            const SizedBox(height: 4),

            // Person name
            Text(
              node.label ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Marga name
            Text(
              node.data.marga ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            // Relationship term (partuturan)
            if (relationshipTerm != null && !isCentral) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  relationshipTerm,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Star for central person
            if (isCentral)
              const Icon(Icons.star, color: Colors.amber, size: 16),
          ],
        ),
      ),
    );
  }
}
