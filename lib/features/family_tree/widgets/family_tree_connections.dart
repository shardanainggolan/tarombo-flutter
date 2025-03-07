import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/utils/family_tree_layout.dart';

class FamilyTreeConnections extends CustomPainter {
  final FamilyGraph familyGraph;
  final Map<int, Offset> nodePositions;
  final List<MarriageGroup> marriageGroups;

  // Constants for node size (must match the actual node size)
  final double nodeWidth = FamilyTreeLayout.NODE_WIDTH;
  final double nodeHeight = FamilyTreeLayout.NODE_HEIGHT;

  FamilyTreeConnections({
    required this.familyGraph,
    required this.nodePositions,
    required this.marriageGroups,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create maps for quick relationship lookup
    final Map<int, int> childToParent = {};
    final Map<int, List<int>> parentToChildren = {};
    final Map<int, List<int>> personToSpouses = {};

    // Build relationship maps
    for (final edge in familyGraph.edges) {
      if (edge.data.relationshipType == 'father' ||
          edge.data.relationshipType == 'mother') {
        childToParent[edge.target] = edge.source;
        parentToChildren.putIfAbsent(edge.source, () => []).add(edge.target);
      } else if (edge.data.relationshipType == 'spouse') {
        personToSpouses.putIfAbsent(edge.source, () => []).add(edge.target);
      }
    }

    // Different paints for different relationship types
    final Paint parentChildPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint spousePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw spouse connections
    for (final entry in personToSpouses.entries) {
      int personId = entry.key;
      List<int> spouseIds = entry.value;

      // Skip if this node doesn't have a position
      if (!nodePositions.containsKey(personId)) continue;

      // Get person node center position
      Offset personPos = nodePositions[personId]!;
      Offset personCenter =
          Offset(personPos.dx + nodeWidth / 2, personPos.dy + nodeHeight / 2);

      // Draw connections to each spouse
      for (final spouseId in spouseIds) {
        // Only process each spouse relationship once
        if (spouseId < personId) continue;

        // Skip if spouse doesn't have a position
        if (!nodePositions.containsKey(spouseId)) continue;

        // Get spouse center position
        Offset spousePos = nodePositions[spouseId]!;
        Offset spouseCenter =
            Offset(spousePos.dx + nodeWidth / 2, spousePos.dy + nodeHeight / 2);

        // Draw horizontal line between spouses
        canvas.drawLine(Offset(personCenter.dx, personCenter.dy),
            Offset(spouseCenter.dx, spouseCenter.dy), spousePaint);
      }
    }

    // Draw parent-child connections
    for (final entry in parentToChildren.entries) {
      int parentId = entry.key;
      List<int> childrenIds = entry.value;

      // Skip if parent doesn't have a position
      if (!nodePositions.containsKey(parentId)) continue;
      if (childrenIds.isEmpty) continue;

      // Get parent bottom center position
      Offset parentPos = nodePositions[parentId]!;
      Offset parentBottom =
          Offset(parentPos.dx + nodeWidth / 2, parentPos.dy + nodeHeight);

      // Filter children with valid positions
      List<int> validChildrenIds =
          childrenIds.where((id) => nodePositions.containsKey(id)).toList();

      if (validChildrenIds.isEmpty) continue;

      // Calculate positions for all valid children
      List<Offset> childrenTops = validChildrenIds.map((id) {
        Offset childPos = nodePositions[id]!;
        return Offset(childPos.dx + nodeWidth / 2, childPos.dy);
      }).toList();

      // Find leftmost and rightmost child
      double leftmostX = childrenTops.map((pos) => pos.dx).reduce(math.min);
      double rightmostX = childrenTops.map((pos) => pos.dx).reduce(math.max);

      // Calculate midpoint Y between parent and children
      double midY = (parentBottom.dy + childrenTops[0].dy) / 2;

      // Draw vertical line from parent to midpoint
      canvas.drawLine(
          parentBottom, Offset(parentBottom.dx, midY), parentChildPaint);

      // If multiple children, draw horizontal line connecting them
      if (childrenTops.length > 1) {
        canvas.drawLine(Offset(leftmostX, midY), Offset(rightmostX, midY),
            parentChildPaint);
      }

      // Draw vertical lines from midpoint to each child
      for (final childTop in childrenTops) {
        canvas.drawLine(Offset(childTop.dx, midY), childTop, parentChildPaint);
      }
    }

    // Modify spouse connection drawing:
    // Instead of drawing direct spouse lines, we'll draw connections
    // from children to the marriage box

    // For each marriage group
    for (final marriage in marriageGroups) {
      // Skip if bounds not calculated
      if (marriage.bounds == Rect.zero) continue;

      // Get the bottom center of the marriage box
      final marriageBottomCenter =
          Offset(marriage.bounds.center.dx, marriage.bounds.bottom);

      // Draw connections from marriage to children
      for (final childId in marriage.childrenIds) {
        // Skip if child position unknown
        if (!nodePositions.containsKey(childId)) continue;

        // Get child top center position
        final childPos = nodePositions[childId]!;
        final childTopCenter = Offset(childPos.dx + nodeWidth / 2, childPos.dy);

        // Calculate midpoint Y between marriage and child
        final midY = (marriageBottomCenter.dy + childTopCenter.dy) / 2;

        // Draw elbow connector: marriage to child
        final path = Path()
          ..moveTo(marriageBottomCenter.dx, marriageBottomCenter.dy)
          ..lineTo(marriageBottomCenter.dx, midY)
          ..lineTo(childTopCenter.dx, midY)
          ..lineTo(childTopCenter.dx, childTopCenter.dy);

        canvas.drawPath(path, parentChildPaint);
      }
    }

    // If there are multiple children from a marriage, draw a horizontal
    // connecting line between them
    for (final marriage in marriageGroups) {
      // Get valid children with positions
      final List<int> validChildrenIds = marriage.childrenIds
          .where((id) => nodePositions.containsKey(id))
          .toList();

      if (validChildrenIds.length <= 1) continue;

      // Calculate positions for all valid children
      List<Offset> childrenTops = validChildrenIds.map((id) {
        Offset childPos = nodePositions[id]!;
        return Offset(childPos.dx + nodeWidth / 2, childPos.dy);
      }).toList();

      // Find leftmost and rightmost child
      double leftmostX = childrenTops.map((pos) => pos.dx).reduce(math.min);
      double rightmostX = childrenTops.map((pos) => pos.dx).reduce(math.max);

      // Calculate midpoint Y between marriage and children
      double midY = (marriage.bounds.bottom + childrenTops[0].dy) / 2;

      // Draw horizontal line connecting all children
      canvas.drawLine(
          Offset(leftmostX, midY), Offset(rightmostX, midY), parentChildPaint);
    }
  }

  @override
  bool shouldRepaint(covariant FamilyTreeConnections oldDelegate) {
    return familyGraph != oldDelegate.familyGraph ||
        nodePositions != oldDelegate.nodePositions;
  }
}
