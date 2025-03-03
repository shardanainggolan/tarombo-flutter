import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/family_tree/models/relationship.dart';
import 'package:tarombo/features/family_tree/repositories/relationship_repository.dart';

// Provider for relationship between two people
final relationshipProvider =
    FutureProvider.family<Relationship, RelationshipParams>(
        (ref, params) async {
  final repository = ref.watch(relationshipRepositoryProvider);
  return repository.getRelationship(params.fromPersonId, params.toPersonId);
});

// Provider for all relationships of a person
final allRelationshipsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>(
        (ref, personId) async {
  final repository = ref.watch(relationshipRepositoryProvider);
  return repository.getAllRelationships(personId);
});

// Parameters for relationship provider
class RelationshipParams {
  final int fromPersonId;
  final int toPersonId;

  RelationshipParams({
    required this.fromPersonId,
    required this.toPersonId,
  });

  @override
  int get hashCode => Object.hash(fromPersonId, toPersonId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationshipParams &&
          runtimeType == other.runtimeType &&
          fromPersonId == other.fromPersonId &&
          toPersonId == other.toPersonId;
}
