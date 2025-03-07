// lib/features/family_tree/widgets/unified_family_tree.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';
import 'package:tarombo/features/family_tree/widgets/family_tree_node.dart';
import 'package:tarombo/features/family_tree/widgets/family_tree_connections.dart';
import 'package:tarombo/features/family_tree/utils/family_tree_layout.dart';
import 'package:tarombo/features/family_tree/widgets/marriage_box_widget.dart';

class UnifiedFamilyTree extends ConsumerStatefulWidget {
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
  ConsumerState<UnifiedFamilyTree> createState() => _UnifiedFamilyTreeState();
}

class _UnifiedFamilyTreeState extends ConsumerState<UnifiedFamilyTree> {
  // Layout engine instance
  late FamilyTreeLayout _layoutEngine;
  // Node positions map
  late Map<int, Offset> _nodePositions;
  // Size of the tree
  late Size _treeSize;

  @override
  void initState() {
    super.initState();
    // Initialize and calculate layout
    _calculateLayout();
  }

  @override
  void didUpdateWidget(UnifiedFamilyTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalculate if graph or central person changes
    if (widget.familyGraph != oldWidget.familyGraph ||
        widget.centralPersonId != oldWidget.centralPersonId) {
      _calculateLayout();
    }
  }

  // Calculate the family tree layout
  void _calculateLayout() {
    _layoutEngine = FamilyTreeLayout();
    _layoutEngine.calculateLayout(widget.familyGraph, widget.centralPersonId);
    _nodePositions = _layoutEngine.nodePositions;
    _treeSize = _layoutEngine.treeSize;

    // Center on the central person after layout calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_nodePositions.containsKey(widget.centralPersonId)) {
        _centerOnNode(widget.centralPersonId);
      }
    });
  }

  // Center the view on a specific node
  void _centerOnNode(int nodeId) {
    if (!_nodePositions.containsKey(nodeId)) return;

    final nodePosition = _nodePositions[nodeId]!;
    final nodeCenter = Offset(nodePosition.dx + FamilyTreeLayout.NODE_WIDTH / 2,
        nodePosition.dy + FamilyTreeLayout.NODE_HEIGHT / 2);

    // Calculate the translation needed to center this node
    // This would need to account for the screen size, etc.
    // For now, a simple reset to identity matrix as placeholder
    widget.transformController.value = Matrix4.identity();

    // Further implementation would adjust the matrix to center on the node
  }

  @override
  Widget build(BuildContext context) {
    // Fetch relationship data for the central person
    final relationshipsAsync =
        ref.watch(allRelationshipsProvider(widget.centralPersonId));

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

    // Add debugging
    print("Tree size: $_treeSize");
    print("Number of nodes with positions: ${_nodePositions.length}");
    print("Number of marriage groups: ${_layoutEngine.marriageGroups.length}");

    // Create a map for quick node lookup
    final Map<int, GraphNode> nodeMap = {};
    for (final node in widget.familyGraph.nodes) {
      nodeMap[node.id] = node;
    }

    return InteractiveViewer(
      transformationController: widget.transformController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 2.0,
      child: Container(
        // Make container large enough to hold the entire tree
        width: _treeSize.width + 100,
        height: _treeSize.height + 100,
        child: Stack(
          children: [
            // Bottom layer: connection lines using CustomPainter
            CustomPaint(
              size: _treeSize,
              painter: FamilyTreeConnections(
                familyGraph: widget.familyGraph,
                nodePositions: _nodePositions,
                marriageGroups: _layoutEngine.marriageGroups,
              ),
            ),

            // Add a debugging layer to visualize bounds
            ...List.generate(
              10,
              (i) => Positioned(
                left: i * 100.0,
                top: 0,
                child: Container(
                  width: 1,
                  height: _treeSize.height,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),

            // Middle layer: marriage boxes
            // Marriage boxes - must come before nodes to be behind them
            ..._layoutEngine.marriageGroups
                .where((mg) => mg.bounds != Rect.zero)
                .map((marriageGroup) {
              print(
                  "Adding marriage box for persons ${marriageGroup.person1Id}-${marriageGroup.person2Id}");
              return MarriageBoxWidget(
                marriageGroup: marriageGroup,
                nodeMap: nodeMap,
              );
            }).toList(),

            // Top layer: person nodes
            ...widget.familyGraph.nodes
                .where((node) => _nodePositions.containsKey(node.id))
                .map((node) {
              final position = _nodePositions[node.id]!;
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: FamilyTreeNode(
                  node: node,
                  isCentral: node.id == widget.centralPersonId,
                  relationshipTerms: relationshipTerms,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
