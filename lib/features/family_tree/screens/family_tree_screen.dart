import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';
import 'package:tarombo/config/constants.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';
import 'package:tarombo/widgets/error_widget.dart';
import 'package:tarombo/widgets/loading_widget.dart';
import 'package:tarombo/features/family_tree/widgets/custom_family_tree.dart';

class FamilyTreeScreen extends ConsumerStatefulWidget {
  final int? personId;

  const FamilyTreeScreen({
    Key? key,
    this.personId,
  }) : super(key: key);

  @override
  ConsumerState<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends ConsumerState<FamilyTreeScreen> {
  late int generationsUp;
  late int generationsDown;
  late TransformationController _transformerController;

  @override
  void initState() {
    super.initState();
    generationsUp = 4; // Increase upward generations (ancestors)
    generationsDown = 3; // Increase downward generations (descendants)
    _transformerController = TransformationController();
  }

  @override
  void dispose() {
    _transformerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the personId if provided, otherwise use the current person ID
    final currentPersonId = ref.watch(currentPersonIdProvider);
    final personId = widget.personId ?? currentPersonId;

    // If no person ID, show a message to link a person
    if (personId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tarombo Batak Toba'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Anda belum memiliki data silsilah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan cari dan hubungkan data diri Anda',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to search screen to find and link person
                },
                child: const Text('Cari Data Diri'),
              ),
            ],
          ),
        ),
      );
    }

    // Watch the family graph data
    final familyGraphAsync = ref.watch(familyGraphProvider(
      FamilyGraphParams(
        personId: personId,
        generationsUp: generationsUp,
        generationsDown: generationsDown,
      ),
    ));

    final relationshipsAsync =
        personId != null ? ref.watch(allRelationshipsProvider(personId)) : null;

    Map<int, String> _buildRelationshipMap(
        List<Map<String, dynamic>> relationships) {
      final map = <int, String>{};

      for (final relation in relationships) {
        final personId = relation['person']['id'] as int;
        final term = relation['term'] as String?;

        if (term != null) {
          map[personId] = term;
        }
      }

      return map;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Silsilah Keluarga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
              // Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              // Navigate to relationships screen
              // Navigator.pushNamed(context, AppRoutes.relationship);
            },
          ),
        ],
      ),
      body: familyGraphAsync.when(
        data: (familyGraph) {
          return CustomFamilyTree(
            familyGraph: familyGraph,
            transformController: _transformerController,
            centralPersonId: personId!,
          );
        },
        error: (error, stackTrace) => CustomErrorWidget(
          message: 'Gagal memuat data silsilah',
          error: error.toString(),
          onRetry: () => ref.refresh(familyGraphProvider(
            FamilyGraphParams(
              personId: personId,
              generationsUp: generationsUp,
              generationsDown: generationsDown,
            ),
          )),
        ),
        loading: () => const CustomLoadingWidget(),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'refresh',
            onPressed: () {
              ref.refresh(familyGraphProvider(
                FamilyGraphParams(
                  personId: personId,
                  generationsUp: generationsUp,
                  generationsDown: generationsDown,
                ),
              ));
            },
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () {
              _transformerController.value = Matrix4.identity()..scale(1.1);
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              _transformerController.value = Matrix4.identity()..scale(0.9);
            },
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'center',
            onPressed: () {
              _transformerController.value = Matrix4.identity();
            },
            child: const Icon(Icons.center_focus_strong),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'generations',
            onPressed: () {
              _showGenerationsDialog(context);
            },
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTree(BuildContext context, FamilyGraph familyGraph,
      Map<int, String> relationshipMap) {
    // Create graph instance
    final Graph graph = Graph()..isTree = true;
    final Map<int, Node> nodeMap = {};

    // Create nodes
    for (final graphNode in familyGraph.nodes) {
      final node = Node.Id(graphNode.id);
      nodeMap[graphNode.id] = node;
      graph.addNode(node);
    }

    // Create edges
    for (final graphEdge in familyGraph.edges) {
      final sourceNode = nodeMap[graphEdge.source];
      final targetNode = nodeMap[graphEdge.target];

      if (sourceNode != null && targetNode != null) {
        final relationshipType = graphEdge.data.relationshipType;

        // Style edges based on relationship type
        final paint = Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

        // Parent-child relationships
        if (relationshipType == "father" || relationshipType == "mother") {
          paint.color = Colors.blue;
          graph.addEdge(sourceNode, targetNode, paint: paint);
        }
        // Spouse relationships
        else if (relationshipType == "spouse") {
          paint.color = Colors.red;
          paint.strokeWidth = 2;
          graph.addEdge(sourceNode, targetNode, paint: paint);
        }
        // Default for other relationships
        else {
          paint.color = Colors.black;
          graph.addEdge(sourceNode, targetNode, paint: paint);
        }
      }
    }

    // Configure the layout algorithm
    final builder = BuchheimWalkerConfiguration()
      ..siblingSeparation =
          200 // Increase sibling spacing for spouse visualization
      ..levelSeparation = 150
      ..subtreeSeparation = 200 // Increase subtree separation
      ..orientation = BuchheimWalkerConfiguration
          .ORIENTATION_LEFT_RIGHT; // Try horizontal layout

    return InteractiveViewer(
      transformationController: _transformerController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 2.0,
      child: GraphView(
        graph: graph,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          // Get node data
          final nodeId = int.parse(node.key!.value.toString());
          final graphNode = familyGraph.nodes.firstWhere((n) => n.id == nodeId);

          return _buildPersonNode(context, graphNode,
              familyGraph.centralPersonId == nodeId, relationshipMap);
        },
      ),
    );
  }

  Widget _buildPersonNode(BuildContext context, GraphNode node, bool isCentral,
      Map<int, String> relationshipMap) {
    // Add null safety to gender check
    final gender = (node.data.gender ?? '').toLowerCase();
    final Color nodeColor = gender == 'male'
        ? Colors.blue.shade100
        : (gender == 'female' ? Colors.pink.shade100 : Colors.grey.shade200);
    final Color borderColor = isCentral ? Colors.red : Colors.grey;

    print(
        "Rendering node: id=${node.id}, name=${node.label}, gender=$gender, color=${nodeColor}");

    final relationshipTerm = relationshipMap[node.id];

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   '/person/${node.id}',
        // );

        GoRouter.of(context).go('/person/${node.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
          minWidth: 100,
          maxWidth: 150,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              node.label ?? 'Unknown', // Add null check
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              node.data.marga ?? '', // Add null check
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            if (relationshipTerm != null) ...[
              const SizedBox(height: 4),
              Text(
                relationshipTerm,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isCentral)
              const Icon(Icons.star, color: Colors.amber, size: 16),
          ],
        ),
      ),
    );
  }

  void _showGenerationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Generasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Generasi ke atas:')),
                DropdownButton<int>(
                  value: generationsUp,
                  items: List.generate(
                      AppConstants.graphMaxGenerationsUp + 1,
                      (index) => DropdownMenuItem(
                            value: index,
                            child: Text('$index'),
                          )),
                  onChanged: (value) {
                    Navigator.pop(context);
                    setState(() {
                      generationsUp = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Text('Generasi ke bawah:')),
                DropdownButton<int>(
                  value: generationsDown,
                  items: List.generate(
                      AppConstants.graphMaxGenerationsDown + 1,
                      (index) => DropdownMenuItem(
                            value: index,
                            child: Text('$index'),
                          )),
                  onChanged: (value) {
                    Navigator.pop(context);
                    setState(() {
                      generationsDown = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
