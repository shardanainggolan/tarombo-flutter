import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';
import 'package:tarombo/features/family_tree/widgets/unified_family_tree.dart'; // Import the new widget
import 'package:tarombo/widgets/error_widget.dart';
import 'package:tarombo/widgets/loading_widget.dart';
import 'package:tarombo/config/constants.dart';

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
    generationsUp = 5; // Increased to show more ancestors
    generationsDown = 3; // Show children and grandchildren
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

    // Watch the family graph data with increased generations
    final familyGraphAsync = ref.watch(familyGraphProvider(
      FamilyGraphParams(
        personId: personId,
        generationsUp: generationsUp,
        generationsDown: generationsDown,
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Silsilah Keluarga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              // Navigate to relationships screen
            },
          ),
          // Add manual refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force refresh of the family graph data
              ref.refresh(familyGraphProvider(
                FamilyGraphParams(
                  personId: personId,
                  generationsUp: generationsUp,
                  generationsDown: generationsDown,
                ),
              ));
            },
          ),
        ],
      ),
      body: familyGraphAsync.when(
        data: (familyGraph) {
          // Use the new unified family tree widget
          return UnifiedFamilyTree(
            familyGraph: familyGraph,
            transformController: _transformerController,
            centralPersonId: personId,
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
            heroTag: 'zoom_in',
            onPressed: () {
              _transformerController.value = _transformerController.value
                ..scale(1.1);
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              _transformerController.value = _transformerController.value
                ..scale(0.9);
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

                    // Refresh with new value
                    ref.refresh(familyGraphProvider(
                      FamilyGraphParams(
                        personId: widget.personId ??
                            ref.read(currentPersonIdProvider),
                        generationsUp: generationsUp,
                        generationsDown: generationsDown,
                      ),
                    ));
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

                    // Refresh with new value
                    ref.refresh(familyGraphProvider(
                      FamilyGraphParams(
                        personId: widget.personId ??
                            ref.read(currentPersonIdProvider),
                        generationsUp: generationsUp,
                        generationsDown: generationsDown,
                      ),
                    ));
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
