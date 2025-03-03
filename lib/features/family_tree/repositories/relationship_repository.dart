import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/core/api/api_client.dart';
import 'package:tarombo/features/family_tree/models/relationship.dart';
import 'package:tarombo/config/constants.dart';

final relationshipRepositoryProvider = Provider<RelationshipRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RelationshipRepository(apiClient);
});

class RelationshipRepository {
  final ApiClient _apiClient;

  RelationshipRepository(this._apiClient);

  // Get relationship between two people
  Future<Relationship> getRelationship(int fromPersonId, int toPersonId) async {
    final response = await _apiClient.get(
      AppConstants.relationshipEndpoint,
      queryParameters: {
        'from_person_id': fromPersonId.toString(),
        'to_person_id': toPersonId.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['success']) {
      final data = response.data['data'];

      return Relationship(
        fromPerson: PersonBasic.fromJson(data['from_person']),
        toPerson: PersonBasic.fromJson(data['to_person']),
        term: data['term'],
        category: data['category'],
        description: data['description'],
        relationshipPath: data['relationship_path'],
      );
    } else {
      throw Exception('Failed to get relationship');
    }
  }

  // Get all relationships for a person
  Future<List<Map<String, dynamic>>> getAllRelationships(int egoPersonId,
      {String? search, int? categoryId}) async {
    final queryParams = {
      'ego_person_id': egoPersonId.toString(),
      if (search != null) 'search': search,
      if (categoryId != null) 'category_id': categoryId.toString(),
    };

    final response = await _apiClient.get(
      AppConstants.allRelationshipsEndpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data['success']) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception('Failed to get relationships');
    }
  }
}
