import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';

class MarriageGroup {
  final int person1Id;
  final int person2Id;
  final List<int> childrenIds;
  Rect bounds = Rect.zero;

  // Add marriage metadata
  final DateTime? marriageDate;
  final DateTime? divorceDate;
  final bool isCurrentMarriage;
  final String? marriageLocation;

  MarriageGroup({
    required this.person1Id,
    required this.person2Id,
    required this.childrenIds,
    this.marriageDate,
    this.divorceDate,
    this.isCurrentMarriage = true,
    this.marriageLocation,
  });
}

class FamilyTreeLayout {
  // Node size constants for calculations
  static const double NODE_WIDTH = 120.0;
  static const double NODE_HEIGHT = 150.0;
  static const double HORIZONTAL_SPACING = 20.0;
  static const double VERTICAL_SPACING = 60.0;

  // Calculated positions for each node
  final Map<int, Offset> nodePositions = {};
  // Track processed nodes to avoid cycles
  final Set<int> processedNodes = {};
  // Map each node to its generation (vertical level)
  final Map<int, int> nodeGenerations = {};
  // Map each generation to its nodes (for horizontal spacing)
  final Map<int, List<int>> generationNodes = {};
  // Size of the entire tree
  Size treeSize = Size.zero;
  // Additional field to track marriage groups
  final List<MarriageGroup> marriageGroups = [];

  // Add this method to identify and create marriage groups
  void _identifyMarriageGroups(FamilyGraph familyGraph) {
    print("Starting marriage group identification");
    marriageGroups.clear();

    // Maps to track relationships
    final Map<int, List<int>> personToSpouses = {};
    final Map<int, int> wifeToHusband = {};
    final Map<int, int> husbandToWife = {};

    // Build relationship maps based on edge data
    for (final edge in familyGraph.edges) {
      // Check relationship type - adjust to match API data structure
      final relationshipType = edge.data.relationshipType.toLowerCase();

      // Debug relationship types
      print("Relationship: ${edge.source} → ${edge.target}: $relationshipType");

      // Detect spouse relationships based on "wife" or "husband" relationshipType
      if (relationshipType == 'wife') {
        // Target is wife, source is husband
        personToSpouses.putIfAbsent(edge.source, () => []).add(edge.target);
        personToSpouses.putIfAbsent(edge.target, () => []).add(edge.source);
        husbandToWife[edge.source] = edge.target;
        wifeToHusband[edge.target] = edge.source;
        print("Found marriage: Husband(${edge.source}) - Wife(${edge.target})");
      } else if (relationshipType == 'husband') {
        // Target is husband, source is wife
        personToSpouses.putIfAbsent(edge.source, () => []).add(edge.target);
        personToSpouses.putIfAbsent(edge.target, () => []).add(edge.source);
        wifeToHusband[edge.source] = edge.target;
        husbandToWife[edge.target] = edge.source;
        print("Found marriage: Wife(${edge.source}) - Husband(${edge.target})");
      }
    }

    // Debugging: Check spouse relationships
    print(
        "Spouse relationships: ${personToSpouses.length} people with spouses");
    print("Husbands with wives: ${husbandToWife.length}");
    print("Wives with husbands: ${wifeToHusband.length}");

    // Track processed marriages to avoid duplicates
    final Set<String> processedMarriages = {};

    // Process marriages from husbands to wives (to ensure consistent processing)
    husbandToWife.forEach((husbandId, wifeId) {
      final marriageKey = "${husbandId}-${wifeId}";

      // Skip if already processed
      if (processedMarriages.contains(marriageKey)) {
        return;
      }
      processedMarriages.add(marriageKey);

      // Find children from this marriage
      final List<int> childrenOfMarriage = [];

      // Build parent-child relationships
      final Map<int, List<int>> parentToChildren =
          _buildParentToChildrenMap(familyGraph);

      // Add children of both spouses
      childrenOfMarriage.addAll(parentToChildren[husbandId] ?? []);
      childrenOfMarriage.addAll(parentToChildren[wifeId] ?? []);

      // Remove duplicates
      final uniqueChildren = childrenOfMarriage.toSet().toList();

      print(
          "Creating marriage: Husband($husbandId) - Wife($wifeId) with ${uniqueChildren.length} children");

      // Create marriage group
      marriageGroups.add(MarriageGroup(
        person1Id: husbandId,
        person2Id: wifeId,
        childrenIds: uniqueChildren,
      ));
    });

    print("Identified ${marriageGroups.length} marriage groups");
  }

  // Process multiple marriages for the same person
  void _processMultipleMarriages() {
    // Group marriages by person
    final Map<int, List<MarriageGroup>> personToMarriages = {};

    for (final marriage in marriageGroups) {
      personToMarriages.putIfAbsent(marriage.person1Id, () => []).add(marriage);
      personToMarriages.putIfAbsent(marriage.person2Id, () => []).add(marriage);
    }

    // For people with multiple marriages, adjust layout
    for (final entry in personToMarriages.entries) {
      final int personId = entry.key;
      final List<MarriageGroup> marriages = entry.value;

      // Skip if only one marriage
      if (marriages.length <= 1) continue;

      // Sort marriages by some criterion (e.g., spouse id for consistency)
      marriages.sort((a, b) {
        // Get the spouse id for this person in each marriage
        final aSpouseId = a.person1Id == personId ? a.person2Id : a.person1Id;
        final bSpouseId = b.person1Id == personId ? b.person2Id : b.person1Id;
        return aSpouseId.compareTo(bSpouseId);
      });

      // Position each spouse vertically stacked rather than side by side
      if (nodePositions.containsKey(personId)) {
        final personPos = nodePositions[personId]!;

        // Start positioning spouses below the person
        double currentY = personPos.dy + NODE_HEIGHT + VERTICAL_SPACING;

        for (final marriage in marriages) {
          // Get spouse id
          final spouseId = marriage.person1Id == personId
              ? marriage.person2Id
              : marriage.person1Id;

          // Skip if spouse position is unknown
          if (!nodePositions.containsKey(spouseId)) continue;

          // Position spouse with consistent X but increasing Y
          nodePositions[spouseId] = Offset(
              personPos.dx, // Keep X aligned with the person
              currentY);

          // Move down for next spouse
          currentY += NODE_HEIGHT + VERTICAL_SPACING;

          // After positioning both spouses, recalculate marriage bounds
          _calculateMarriageGroupBounds();

          // Now position the children of this marriage
          _positionChildrenForMarriage(marriage, personPos.dx);
        }
      }
    }
  }

// Position children for a specific marriage
  void _positionChildrenForMarriage(MarriageGroup marriage, double centerX) {
    final List<int> validChildrenIds = marriage.childrenIds
        .where((id) => nodePositions.containsKey(id))
        .toList();

    if (validChildrenIds.isEmpty) return;

    // Get the bottom of the marriage box
    final double startY = marriage.bounds.bottom + VERTICAL_SPACING;

    // Calculate total width needed for all children
    final double totalWidth = validChildrenIds.length * NODE_WIDTH +
        (validChildrenIds.length - 1) * HORIZONTAL_SPACING;

    // Calculate starting X to center children under marriage
    double startX = centerX - totalWidth / 2;

    // Position each child
    for (int i = 0; i < validChildrenIds.length; i++) {
      final childId = validChildrenIds[i];

      // Position child
      nodePositions[childId] =
          Offset(startX + i * (NODE_WIDTH + HORIZONTAL_SPACING), startY);
    }
  }

  // Main layout calculation function
  void calculateLayout(FamilyGraph familyGraph, int centralPersonId) {
    // Clear previous state
    nodePositions.clear();
    processedNodes.clear();
    nodeGenerations.clear();
    generationNodes.clear();
    marriageGroups.clear();

    print("Starting layout calculation for central person: $centralPersonId");

    // Build relationship maps
    final Map<int, int> childToParent = _buildChildToParentMap(familyGraph);
    final Map<int, List<int>> parentToChildren =
        _buildParentToChildrenMap(familyGraph);
    final Map<int, List<int>> personToSpouses = _buildSpouseMap(familyGraph);

    // Step 1: Identify marriage groups FIRST
    _identifyMarriageGroups(familyGraph);
    print("Identified ${marriageGroups.length} marriage groups");

    // Step 2: Find top ancestor
    final int topAncestorId = _findTopAncestor(centralPersonId, childToParent);
    print("Top ancestor: $topAncestorId");

    // Step 3: Assign generations (vertical levels)
    _assignGenerations(topAncestorId, parentToChildren, 0);
    print("Assigned generations to ${nodeGenerations.length} nodes");

    // Step 4: Calculate horizontal positions for each generation
    _assignHorizontalPositions(personToSpouses);
    print("Assigned horizontal positions to ${nodePositions.length} nodes");

    // Step 5: Process multiple marriages if any
    _processMultipleMarriages();

    // Step 6: Calculate marriage group bounds AFTER node positioning
    _calculateMarriageGroupBounds();
    print("Calculated bounds for ${marriageGroups.length} marriage groups");

    // Step 7: Final adjustments
    _calculateFinalPositions();

    // Step 8: Calculate overall tree size
    _calculateTreeSize();
    print("Final tree size: $treeSize");
  }

  // Calculate bounds for marriage groups
  void _calculateMarriageGroupBounds() {
    print("Calculating bounds for ${marriageGroups.length} marriage groups");

    for (final group in marriageGroups) {
      // Skip if either spouse position is unknown
      if (!nodePositions.containsKey(group.person1Id) ||
          !nodePositions.containsKey(group.person2Id)) {
        print(
            "⚠️ Marriage group bound calculation skipped - missing positions for spouses ${group.person1Id} or ${group.person2Id}");
        continue;
      }

      // Get positions for both spouses
      final position1 = nodePositions[group.person1Id]!;
      final position2 = nodePositions[group.person2Id]!;

      // Debug output
      print("Spouse 1 position: $position1");
      print("Spouse 2 position: $position2");

      // Calculate the bounds of the marriage box with extra padding for visibility
      final double left = math.min(position1.dx, position2.dx) - 20;
      final double top = math.min(position1.dy, position2.dy) - 15;
      final double right =
          math.max(position1.dx + NODE_WIDTH, position2.dx + NODE_WIDTH) + 20;
      final double bottom =
          math.max(position1.dy + NODE_HEIGHT, position2.dy + NODE_HEIGHT) + 15;

      print("Marriage bounds calculated: L:$left, T:$top, R:$right, B:$bottom");

      // Ensure bounds are valid
      if (right > left && bottom > top) {
        group.bounds = Rect.fromLTRB(left, top, right, bottom);
        print("Set marriage bounds: ${group.bounds}");
      } else {
        print(
            "⚠️ Invalid marriage bounds calculated: L:$left, T:$top, R:$right, B:$bottom");
      }
    }
  }

  // Find the top ancestor starting from a person
  int _findTopAncestor(int personId, Map<int, int> childToParent) {
    int currentId = personId;
    int previousId;

    // Navigate up the tree until we reach a node without a parent
    do {
      previousId = currentId;
      currentId = childToParent[currentId] ?? previousId;
    } while (currentId != previousId);

    return currentId;
  }

  // Assign generation numbers (vertical positions)
  void _assignGenerations(
      int nodeId, Map<int, List<int>> parentToChildren, int generation) {
    if (processedNodes.contains(nodeId)) return;
    processedNodes.add(nodeId);

    // Assign this node to its generation
    nodeGenerations[nodeId] = generation;
    generationNodes.putIfAbsent(generation, () => []).add(nodeId);

    // Process all children at next generation
    for (final childId in parentToChildren[nodeId] ?? []) {
      _assignGenerations(childId, parentToChildren, generation + 1);
    }
  }

  // Assign horizontal positions within each generation
  void _assignHorizontalPositions(Map<int, List<int>> personToSpouses) {
    // Sort generations from top (min) to bottom (max)
    final List<int> sortedGenerations = generationNodes.keys.toList()..sort();

    double maxWidth = 0;

    // Process each generation
    for (final genLevel in sortedGenerations) {
      final List<int> nodesInGeneration = generationNodes[genLevel] ?? [];

      // Skip empty generations
      if (nodesInGeneration.isEmpty) continue;

      double totalWidth = nodesInGeneration.length * NODE_WIDTH +
          (nodesInGeneration.length - 1) * HORIZONTAL_SPACING;

      // Add space for spouses
      for (final nodeId in nodesInGeneration) {
        // Each spouse adds width
        int spouseCount = personToSpouses[nodeId]?.length ?? 0;
        if (spouseCount > 0) {
          totalWidth += spouseCount * (NODE_WIDTH + HORIZONTAL_SPACING);
        }
      }

      // Update max width
      maxWidth = math.max(maxWidth, totalWidth);

      // Position nodes within this generation
      double currentX = 0;
      for (int i = 0; i < nodesInGeneration.length; i++) {
        int nodeId = nodesInGeneration[i];

        // Center children under their parent
        // This is a simplified approach; a more complex algorithm would
        // position children more intelligently
        nodePositions[nodeId] =
            Offset(currentX, genLevel * (NODE_HEIGHT + VERTICAL_SPACING));

        // Move to next position, accounting for spacing
        currentX += NODE_WIDTH + HORIZONTAL_SPACING;
      }
    }

    // Additional logic to handle multiple marriages:
    // We need to ensure each spouse in multiple marriages gets proper positioning

    // First pass to position primary nodes
    // Then second pass to adjust for multiple marriages

    // For each person with multiple spouses, position them with adequate spacing
    for (final entry in personToSpouses.entries) {
      final int personId = entry.key;
      final List<int> spouses = entry.value;

      // Skip if person has 0-1 spouses (handled by normal positioning)
      if (spouses.length <= 1) continue;

      // If this person has multiple spouses (marriages), we need to space them out
      double baseX = nodePositions[personId]?.dx ?? 0;
      double spacingMultiplier = 1.0;

      // Adjust the position of each spouse
      for (int i = 0; i < spouses.length; i++) {
        final int spouseId = spouses[i];

        // Skip if spouse position is unknown
        if (!nodePositions.containsKey(spouseId)) continue;

        // Position spouse with increasing spacing for each additional marriage
        nodePositions[spouseId] = Offset(
            baseX + (NODE_WIDTH + HORIZONTAL_SPACING) * spacingMultiplier,
            nodePositions[spouseId]!.dy);

        // Increment spacing for next spouse
        spacingMultiplier += 1.0;
      }
    }
  }

  // Calculate final positions with adjustments
  void _calculateFinalPositions() {
    // This would implement advanced positioning logic
    // For example, centering children under parents
    // For now, we'll use the basic positions already calculated
  }

  // Calculate the overall size of the tree
  void _calculateTreeSize() {
    double maxX = 0;
    double maxY = 0;

    for (final position in nodePositions.values) {
      maxX = math.max(maxX, position.dx + NODE_WIDTH);
      maxY = math.max(maxY, position.dy + NODE_HEIGHT);
    }

    treeSize = Size(maxX, maxY);
  }

  // Build a map of child to parent
  Map<int, int> _buildChildToParentMap(FamilyGraph familyGraph) {
    final Map<int, int> childToParent = {};

    for (final edge in familyGraph.edges) {
      final relationshipType = edge.data.relationshipType.toLowerCase();

      // Match API relationship types
      if (relationshipType == 'son' || relationshipType == 'daughter') {
        // Source is parent, target is child
        childToParent[edge.target] = edge.source;
      } else if (relationshipType == 'father' || relationshipType == 'mother') {
        // Source is child, target is parent
        childToParent[edge.source] = edge.target;
      }
    }

    return childToParent;
  }

  // Build a map of parent to children
  Map<int, List<int>> _buildParentToChildrenMap(FamilyGraph familyGraph) {
    final Map<int, List<int>> parentToChildren = {};

    for (final edge in familyGraph.edges) {
      final relationshipType = edge.data.relationshipType.toLowerCase();

      // Match API relationship types
      if (relationshipType == 'son' || relationshipType == 'daughter') {
        // Source is parent, target is child
        parentToChildren.putIfAbsent(edge.source, () => []).add(edge.target);
      } else if (relationshipType == 'father' || relationshipType == 'mother') {
        // Source is child, target is parent
        parentToChildren.putIfAbsent(edge.target, () => []).add(edge.source);
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
}
