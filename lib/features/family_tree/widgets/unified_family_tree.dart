import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';

/// A unified family tree visualization that ensures proper connected lines
class UnifiedFamilyTree extends ConsumerWidget {
  final FamilyGraph familyGraph;
  final TransformationController transformController;
  final int centralPersonId;

  const UnifiedFamilyTree({
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

    // Create a map for quick node lookup
    final Map<int, GraphNode> nodeMap = {};
    for (final node in familyGraph.nodes) {
      nodeMap[node.id] = node;
    }

    // Build family relationship maps
    final Map<int, int> childToParent = _buildChildToParentMap(familyGraph);
    final Map<int, List<int>> parentToChildren =
        _buildParentToChildrenMap(familyGraph);
    final Map<int, List<int>> personToSpouses = _buildSpouseMap(familyGraph);

    // Find the top ancestor
    final topAncestorId = _findTopAncestor(centralPersonId, childToParent);

    return InteractiveViewer(
      transformationController: transformController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 2.0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          // Build a unified tree starting from top ancestor
          child: _buildUnifiedTree(
            context,
            topAncestorId,
            nodeMap,
            childToParent,
            parentToChildren,
            personToSpouses,
            relationshipTerms,
            Set<int>(), // Track processed IDs to avoid duplicates
          ),
        ),
      ),
    );
  }

  // Build a map of child to parent relationships
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

  // Build a map of parent to children relationships
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

  // Build the entire family tree as a unified structure
  Widget _buildUnifiedTree(
    BuildContext context,
    int personId,
    Map<int, GraphNode> nodeMap,
    Map<int, int> childToParent,
    Map<int, List<int>> parentToChildren,
    Map<int, List<int>> personToSpouses,
    Map<int, String> relationshipTerms,
    Set<int> processedIds,
  ) {
    // Skip if already processed
    if (processedIds.contains(personId)) {
      return Container();
    }

    // Mark as processed
    processedIds.add(personId);

    // Get the person node
    final person = nodeMap[personId];
    if (person == null) return Container();

    // Get spouse(s)
    final spouseIds = personToSpouses[personId] ?? [];
    final children = parentToChildren[personId] ?? [];

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

            // First spouse (if any)
            if (spouseIds.isNotEmpty &&
                nodeMap.containsKey(spouseIds.first)) ...[
              // Horizontal connector to spouse
              Container(
                width: 40,
                height: 2,
                color: Colors.red,
              ),
              _buildPersonNode(
                context,
                nodeMap[spouseIds.first]!,
                spouseIds.first == centralPersonId,
                relationshipTerms,
              ),

              // Mark spouse as processed
              if (spouseIds.isNotEmpty)
                Builder(builder: (context) {
                  processedIds.add(spouseIds.first);
                  return Container();
                }),
            ],
          ],
        ),

        // Children section
        if (children.isNotEmpty) ...[
          // Vertical connector to children
          Container(
            width: 2,
            height: 30,
            color: Colors.black,
          ),

          // Build the children section
          _buildChildrenSection(
            context,
            children,
            nodeMap,
            childToParent,
            parentToChildren,
            personToSpouses,
            relationshipTerms,
            processedIds,
          ),
        ],
      ],
    );
  }

  // Build a section containing all children with their own subtrees
  Widget _buildChildrenSection(
    BuildContext context,
    List<int> childrenIds,
    Map<int, GraphNode> nodeMap,
    Map<int, int> childToParent,
    Map<int, List<int>> parentToChildren,
    Map<int, List<int>> personToSpouses,
    Map<int, String> relationshipTerms,
    Set<int> processedIds,
  ) {
    // Filter out any null nodes
    final validChildrenIds =
        childrenIds.where((id) => nodeMap.containsKey(id)).toList();

    if (validChildrenIds.isEmpty) return Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Horizontal line to connect all children
        if (validChildrenIds.length > 1)
          Container(
            width: validChildrenIds.length * 200.0,
            height: 2,
            color: Colors.black,
          ),

        // Row of children with their subtrees
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final childId in validChildrenIds)
              Container(
                width: 200,
                child: Column(
                  children: [
                    // Vertical connector to child
                    if (validChildrenIds.length > 1)
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.black,
                      ),

                    // Child's subtree
                    _buildUnifiedTree(
                      context,
                      childId,
                      nodeMap,
                      childToParent,
                      parentToChildren,
                      personToSpouses,
                      relationshipTerms,
                      processedIds,
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
