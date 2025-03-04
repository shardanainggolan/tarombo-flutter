import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/models/family_unit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';

class CustomFamilyTree extends ConsumerWidget {
  final FamilyGraph familyGraph;
  final TransformationController transformController;
  final int centralPersonId;

  const CustomFamilyTree({
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

    final familyUnits = _processFamilyUnits(familyGraph);
    final generationMap = _organizeByGeneration(familyUnits);

    // Create a map of relationship terms based on person IDs
    Map<int, String> relationshipTerms = {};

    if (relationshipsAsync.value != null) {
      // Extract relationship terms from the API response
      for (final relationship in relationshipsAsync.value!) {
        final personId = relationship['person']['id'] as int?;
        final term = relationship['term'] as String?;

        if (personId != null && term != null) {
          relationshipTerms[personId] = term;
        }
      }
    }

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
            children: [
              for (int gen = 0; gen <= generationMap.keys.length; gen++)
                if (generationMap.containsKey(gen))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final unit in generationMap[gen] ?? [])
                          _buildFamilyUnitWidget(
                              context, unit, relationshipTerms),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  List<FamilyUnit> _processFamilyUnits(FamilyGraph familyGraph) {
    // Establish parent-child relationships map
    final Map<int, List<int>> parentToChildren = {};
    final Map<int, int> childToParent = {};

    // Process all edges to build relationship maps
    for (final edge in familyGraph.edges) {
      if (edge.data.relationshipType == 'father' ||
          edge.data.relationshipType == 'mother') {
        // Record parent-child relationship
        parentToChildren.putIfAbsent(edge.source, () => []).add(edge.target);
        childToParent[edge.target] = edge.source;
      }
    }

    // Build unified family units from the top down
    final List<FamilyUnit> familyUnits = [];
    final Set<int> processedParents = {};

    // Find all top-level parents (people without parents themselves)
    final topLevelParents = parentToChildren.keys
        .where((id) => !childToParent.containsKey(id))
        .toList();

    // If no top-level parents found, start with the central person's highest ancestor
    if (topLevelParents.isEmpty) {
      int currentPerson = familyGraph.centralPersonId;
      // Traverse up to find highest ancestor
      while (childToParent.containsKey(currentPerson)) {
        currentPerson = childToParent[currentPerson]!;
      }
      topLevelParents.add(currentPerson);
    }

    // Process family starting from top-level parents
    for (final parentId in topLevelParents) {
      _processFamilyBranch(
        parentId,
        familyGraph,
        parentToChildren,
        familyUnits,
        processedParents,
      );
    }

    return familyUnits;
  }

  // Recursively process a family branch starting from a parent
  void _processFamilyBranch(
    int personId,
    FamilyGraph familyGraph,
    Map<int, List<int>> parentToChildren,
    List<FamilyUnit> familyUnits,
    Set<int> processedParents,
  ) {
    // Skip if already processed
    if (processedParents.contains(personId)) return;
    processedParents.add(personId);

    // Find person node
    final personNode = familyGraph.nodes.firstWhere(
      (n) => n.id == personId,
      orElse: () => throw Exception('Person node not found'),
    );

    // Find spouse relationships
    final spouseEdges = familyGraph.edges
        .where((e) =>
            (e.source == personId || e.target == personId) &&
            e.data.relationshipType == 'spouse')
        .toList();

    // Extract spouse nodes
    final spouseNodes = <GraphNode>[];
    for (final edge in spouseEdges) {
      final spouseId = edge.source == personId ? edge.target : edge.source;
      final spouseNode = familyGraph.nodes.firstWhere(
        (n) => n.id == spouseId,
        orElse: () => throw Exception('Spouse node not found'),
      );
      spouseNodes.add(spouseNode);
    }

    // Find all children of this person
    final childrenIds = parentToChildren[personId] ?? [];
    final childNodes = <GraphNode>[];

    for (final childId in childrenIds) {
      final childNode = familyGraph.nodes.firstWhere(
        (n) => n.id == childId,
        orElse: () => throw Exception('Child node not found'),
      );
      childNodes.add(childNode);
    }

    // Create family unit for this person
    familyUnits.add(FamilyUnit(
      primaryPerson: personNode,
      spouses: spouseNodes,
      children: childNodes,
    ));

    // Recursively process each child's family
    for (final childId in childrenIds) {
      // Only process children who are themselves parents
      if (parentToChildren.containsKey(childId)) {
        _processFamilyBranch(
          childId,
          familyGraph,
          parentToChildren,
          familyUnits,
          processedParents,
        );
      }
    }
  }

  Map<int, List<FamilyUnit>> _organizeByGeneration(List<FamilyUnit> units) {
    final Map<int, List<FamilyUnit>> generationMap = {};
    final Map<int, int> generationAssignments = {};

    // Create parent-child relationship maps for generation assignment
    final Map<int, int> childToParent = {};
    final Map<int, List<int>> personToUnits = {};

    // Map people to family units and build relationship map
    for (int i = 0; i < units.length; i++) {
      final unit = units[i];
      final personId = unit.primaryPerson.id;

      // Map this person to their unit index
      personToUnits.putIfAbsent(personId, () => []).add(i);

      // Record parent-child relationships
      for (final child in unit.children) {
        childToParent[child.id] = personId;
      }
    }

    // Find the central person's generation number
    int centralPersonId = familyGraph.centralPersonId;
    int centralPersonGeneration = 0;

    // Account for generations above central person
    int tempPerson = centralPersonId;
    while (childToParent.containsKey(tempPerson)) {
      centralPersonGeneration++;
      tempPerson = childToParent[tempPerson]!;
    }

    // Assign generation 0 to top-level ancestor
    generationAssignments[tempPerson] = 0;

    // Assign generations to all family members
    bool changed = true;
    while (changed) {
      changed = false;

      for (int i = 0; i < units.length; i++) {
        final unit = units[i];
        final personId = unit.primaryPerson.id;

        // If person has assigned generation
        if (generationAssignments.containsKey(personId)) {
          final personGen = generationAssignments[personId]!;

          // Assign spouse to same generation
          for (final spouse in unit.spouses) {
            if (!generationAssignments.containsKey(spouse.id) ||
                generationAssignments[spouse.id] != personGen) {
              generationAssignments[spouse.id] = personGen;
              changed = true;
            }
          }

          // Assign children to next generation
          for (final child in unit.children) {
            if (!generationAssignments.containsKey(child.id) ||
                generationAssignments[child.id] != personGen + 1) {
              generationAssignments[child.id] = personGen + 1;
              changed = true;
            }
          }

          // Assign parent to previous generation
          if (childToParent.containsKey(personId)) {
            final parentId = childToParent[personId]!;
            if (!generationAssignments.containsKey(parentId) ||
                generationAssignments[parentId] != personGen - 1) {
              generationAssignments[parentId] = personGen - 1;
              changed = true;
            }
          }
        } else if (personId == tempPerson) {
          // Assign top ancestor to generation 0
          generationAssignments[personId] = 0;
          changed = true;
        }
      }
    }

    // Group units by generation
    for (int i = 0; i < units.length; i++) {
      final unit = units[i];
      final personId = unit.primaryPerson.id;
      final generation = generationAssignments[personId] ?? 0;

      generationMap.putIfAbsent(generation, () => []).add(unit);
    }

    return generationMap;
  }

  Widget _buildGenerationRow(BuildContext context, List<FamilyUnit> units,
      Map<int, String> relationshipTerms) {
    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: [
        for (final unit in units)
          _buildFamilyUnitWidget(context, unit, relationshipTerms),
      ],
    );
  }

  Widget _buildFamilyUnitWidget(BuildContext context, FamilyUnit unit,
      Map<int, String> relationshipTerms) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (unit.parents.isNotEmpty) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final parent in unit.parents)
                _buildPersonNode(
                  context,
                  parent,
                  parent.id == familyGraph.centralPersonId,
                  relationshipTerms,
                ),
            ],
          ),
          // Connector line from parents to person
          Container(
            width: 2,
            height: 30,
            color: Colors.black,
          ),
        ],

        // Spouse section
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPersonNode(
              context,
              unit.primaryPerson,
              unit.primaryPerson.id == familyGraph.centralPersonId,
              relationshipTerms,
            ),
            if (unit.spouses.isNotEmpty) ...[
              Container(
                width: 40,
                height: 2,
                color: Colors.red,
              ),
              _buildPersonNode(
                context,
                unit.spouses.first, // Simplification for now
                unit.spouses.first.id == familyGraph.centralPersonId,
                relationshipTerms,
              ),
            ],
          ],
        ),

        // Children connector
        if (unit.children.isNotEmpty) ...[
          Container(
            width: 2,
            height: 20,
            color: Colors.black,
          ),

          // If multiple children, add horizontal connector
          if (unit.children.length > 1)
            Container(
              width: math.max((unit.children.length - 1) * 130, 100),
              height: 2,
              color: Colors.black,
            ),

          // Children row
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final child in unit.children)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // Vertical connector to each child
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.black,
                      ),
                      _buildPersonNode(
                        context,
                        child,
                        child.id == familyGraph.centralPersonId,
                        relationshipTerms,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPersonNode(BuildContext context, GraphNode node, bool isCentral,
      Map<int, String> relationshipTerms) {
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
        constraints: const BoxConstraints(
          minWidth: 120,
          maxWidth: 150,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Person icon
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
            const SizedBox(height: 4),
            // Marga name
            Text(
              node.data.marga ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            // Add relationship term display
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

            if (isCentral)
              const Icon(Icons.star, color: Colors.amber, size: 16),
          ],
        ),
      ),
    );
  }
}
