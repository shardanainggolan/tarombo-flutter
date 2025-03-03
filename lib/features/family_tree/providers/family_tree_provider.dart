import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/models/family_graph_adapter.dart';
import 'package:tarombo/features/family_tree/models/person.dart';
import 'package:tarombo/features/family_tree/repositories/family_repository.dart';
import 'package:tarombo/core/services/storage_service.dart';

// Provider for family graph data
final familyGraphProvider =
    FutureProvider.family<FamilyGraph, FamilyGraphParams>((ref, params) async {
  final repository = ref.watch(familyRepositoryProvider);
  return repository.getFamilyGraph(
    personId: params.personId,
    generationsUp: params.generationsUp,
    generationsDown: params.generationsDown,
  );
});

// Provider for person details
final personDetailsProvider =
    FutureProvider.family<Person, int>((ref, personId) async {
  final repository = ref.watch(familyRepositoryProvider);
  return repository.getPersonDetails(personId);
});

// Provider for current person ID (the one linked to user account)
final currentPersonIdProvider = Provider<int?>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getPersonId();
});

// Parameters for family graph provider
class FamilyGraphParams {
  final int? personId;
  final int generationsUp;
  final int generationsDown;

  FamilyGraphParams({
    this.personId,
    this.generationsUp = 1,
    this.generationsDown = 1,
  });

  @override
  int get hashCode => Object.hash(personId, generationsUp, generationsDown);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyGraphParams &&
          runtimeType == other.runtimeType &&
          personId == other.personId &&
          generationsUp == other.generationsUp &&
          generationsDown == other.generationsDown;
}
