import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tarombo/features/family_tree/models/person.dart';
import 'package:tarombo/features/family_tree/providers/family_tree_provider.dart';
import 'package:tarombo/features/family_tree/providers/relationship_provider.dart';
import 'package:tarombo/widgets/error_widget.dart';
import 'package:tarombo/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonDetailScreen extends ConsumerWidget {
  final int personId;

  const PersonDetailScreen({
    Key? key,
    required this.personId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personDetailsProvider(personId));
    final currentPersonId = ref.watch(currentPersonIdProvider);

    // If the current user has a linked person record, we can show relationship info
    final relationshipAsync =
        currentPersonId != null && currentPersonId != personId
            ? ref.watch(relationshipProvider(
                RelationshipParams(
                  fromPersonId: currentPersonId,
                  toPersonId: personId,
                ),
              ))
            : null;

    return Scaffold(
      appBar: AppBar(
        title: personAsync.maybeWhen(
          data: (person) => Text(person.fullName),
          orElse: () => const Text('Detail Orang'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.family_restroom),
            onPressed: () {
              // Navigate to family tree centered on this person
              Navigator.pushNamed(
                context,
                '/family-tree',
                arguments: {'personId': personId},
              );
            },
          ),
        ],
      ),
      body: personAsync.when(
        data: (person) =>
            _buildPersonDetail(context, person, relationshipAsync),
        error: (error, stackTrace) => CustomErrorWidget(
          message: 'Gagal memuat data orang',
          error: error.toString(),
          onRetry: () => ref.refresh(personDetailsProvider(personId)),
        ),
        loading: () => const CustomLoadingWidget(),
      ),
    );
  }

  Widget _buildPersonDetail(
    BuildContext context,
    Person person,
    AsyncValue<dynamic>? relationshipAsync,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Person header with photo
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Person photo
                  _buildPersonPhoto(person),
                  const SizedBox(width: 16),
                  // Person basic info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          person.margaName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            Icons.person,
                            person.gender == 'male'
                                ? 'Laki-laki'
                                : 'Perempuan'),
                        if (person.birthDate != null)
                          _buildInfoRow(Icons.cake,
                              DateFormat('d MMMM y').format(person.birthDate!)),
                        if (person.deathDate != null)
                          _buildInfoRow(Icons.memory,
                              'Meninggal: ${DateFormat('d MMMM y').format(person.deathDate!)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Relationship info if available
          if (relationshipAsync != null) ...[
            const SizedBox(height: 16),
            _buildRelationshipCard(context, relationshipAsync),
          ],

          // Notes section
          if (person.notes != null && person.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Catatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(person.notes!),
              ),
            ),
          ],

          // Family buttons
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFamilyButton(
                context,
                Icons.people,
                'Orang Tua & Saudara',
                () {
                  // Navigate to parents and siblings view
                },
              ),
              _buildFamilyButton(
                context,
                Icons.favorite,
                person.gender == 'male' ? 'Istri & Anak' : 'Suami & Anak',
                () {
                  // Navigate to spouse and children view
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonPhoto(Person person) {
    if (person.photoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: person.photoUrl!,
          width: 100,
          height: 120,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 100,
            height: 120,
            color: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          errorWidget: (context, url, error) => Container(
            width: 100,
            height: 120,
            color: Colors.grey.shade300,
            child: const Icon(Icons.error, size: 40, color: Colors.grey),
          ),
        ),
      );
    } else {
      return Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: person.gender == 'male'
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.person,
          size: 50,
          color: person.gender == 'male'
              ? Colors.blue.shade900
              : Colors.pink.shade900,
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard(
      BuildContext context, AsyncValue<dynamic> relationshipAsync) {
    return relationshipAsync.when(
      data: (relationship) {
        if (relationship.term == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text('Tidak ada hubungan yang diketahui dengan orang ini.'),
            ),
          );
        }

        return Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hubungan dengan Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Partuturan: ${relationship.term}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                if (relationship.category != null) ...[
                  const SizedBox(height: 4),
                  Text('Kategori: ${relationship.category}'),
                ],
                if (relationship.description != null) ...[
                  const SizedBox(height: 8),
                  Text(relationship.description!),
                ],
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gagal memuat data hubungan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
            ],
          ),
        ),
      ),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
