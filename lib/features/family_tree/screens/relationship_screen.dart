import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';
import 'package:tarombo/widgets/error_widget.dart';
import 'package:tarombo/widgets/loading_widget.dart';

class RelationshipScreen extends ConsumerWidget {
  const RelationshipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPersonId = ref.watch(currentPersonIdProvider);

    // If no person ID, show a message to link a person
    if (currentPersonId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Partuturan'),
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

    // Watch the relationships data
    final relationshipsAsync =
        ref.watch(allRelationshipsProvider(currentPersonId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Partuturan'),
      ),
      body: relationshipsAsync.when(
        data: (relationships) =>
            _buildRelationshipsList(context, relationships),
        error: (error, stackTrace) => CustomErrorWidget(
          message: 'Gagal memuat data partuturan',
          error: error.toString(),
          onRetry: () => ref.refresh(allRelationshipsProvider(currentPersonId)),
        ),
        loading: () => const CustomLoadingWidget(),
      ),
    );
  }

  Widget _buildRelationshipsList(
      BuildContext context, List<Map<String, dynamic>> relationships) {
    if (relationships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada data partuturan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    // Group relationships by category
    final groupedRelationships = <String, List<Map<String, dynamic>>>{};

    for (final relation in relationships) {
      final category = relation['category'] ?? 'Lainnya';
      if (!groupedRelationships.containsKey(category)) {
        groupedRelationships[category] = [];
      }
      groupedRelationships[category]!.add(relation);
    }

    return ListView.builder(
      itemCount: groupedRelationships.length,
      itemBuilder: (context, index) {
        final category = groupedRelationships.keys.elementAt(index);
        final categoryRelations = groupedRelationships[category]!;

        return ExpansionTile(
          title: Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          initiallyExpanded: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryRelations.length,
              itemBuilder: (context, relationIndex) {
                final relation = categoryRelations[relationIndex];
                final person = relation['person'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: person['gender'] == 'male'
                        ? Colors.blue.shade100
                        : Colors.pink.shade100,
                    child: Icon(
                      Icons.person,
                      color: person['gender'] == 'male'
                          ? Colors.blue.shade900
                          : Colors.pink.shade900,
                    ),
                  ),
                  title: Text(person['first_name'] + ' ' + person['last_name']),
                  subtitle: Row(
                    children: [
                      const Text('Partuturan: '),
                      Text(
                        relation['term'] ?? 'Tidak diketahui',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to person detail
                    // Navigator.pushNamed(
                    //   context,
                    //   '/person/${person['id']}',
                    // );

                    GoRouter.of(context).go('/person/${person['id']}');
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
