import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/core/api/api_client.dart';
import 'package:tarombo/features/family_tree/models/family_graph.dart';
import 'package:tarombo/features/family_tree/models/family_graph_adapter.dart';
import 'package:tarombo/features/family_tree/models/person.dart';
import 'package:tarombo/config/constants.dart';

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FamilyRepository(apiClient);
});

class FamilyRepository {
  final ApiClient _apiClient;

  FamilyRepository(this._apiClient);

  // Get family graph data
  Future<FamilyGraph> getFamilyGraph({
    int? personId,
    int generationsUp = 1,
    int generationsDown = 1,
  }) async {
    final queryParams = {
      if (personId != null) 'person_id': personId.toString(),
      'generations_up': generationsUp.toString(),
      'generations_down': generationsDown.toString(),
    };

    try {
      final response = await _apiClient.get(
        AppConstants.familyGraphEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        final meta = response.data['meta'];

        // Use the adapter instead of direct fromJson conversion
        return FamilyGraph(
          nodes: (data['nodes'] as List?)
                  ?.map((node) => FamilyGraphAdapter.nodeFromJson(node))
                  .toList() ??
              [],
          edges: (data['edges'] as List?)
                  ?.map((edge) => FamilyGraphAdapter.edgeFromJson(edge))
                  .toList() ??
              [],
          centralPersonId: meta['central_person_id'] ?? 0,
        );
      } else {
        throw Exception('Failed to get family graph');
      }
    } catch (e, stack) {
      // Enhanced error diagnostics
      print('Error fetching family graph: $e');
      print('Stack trace: $stack');

      // Attempt to identify problematic nodes if applicable
      if (e
          .toString()
          .contains('type \'Null\' is not a subtype of type \'String\'')) {
        _logNodeIssuesFromLastResponse();
      }

      rethrow;
    }
  }

  // Optional diagnostic helper
  void _logNodeIssuesFromLastResponse() {
    try {
      if (_lastResponse != null && _lastResponse!['data'] != null) {
        final responseData = _lastResponse!['data'];

        if (responseData['nodes'] != null) {
          print('Analyzing nodes for null fields:');
          final nodes = responseData['nodes'] as List;

          for (int i = 0; i < nodes.length; i++) {
            final node = nodes[i];
            print('Node $i:');
            print('  - id: ${node['id']}');
            print('  - label: ${node['label']}');

            if (node['data'] != null) {
              print('  - data.fullName: ${node['data']['fullName']}');
              print('  - data.gender: ${node['data']['gender']}');
              print('  - data.marga: ${node['data']['marga']}');
            } else {
              print('  - data field is NULL');
            }
          }
        }
      }
    } catch (e) {
      print('Error while logging node issues: $e');
    }
  }

  // Store last response for debugging
  Map<String, dynamic>? _lastResponse;

  // Get person details
  Future<Person> getPersonDetails(int personId) async {
    final response =
        await _apiClient.get('${AppConstants.personEndpoint}/$personId');

    if (response.statusCode == 200 && response.data['success']) {
      final data = response.data['data'];

      return Person(
        id: data['id'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        gender: data['gender'],
        margaId: data['marga']['id'],
        margaName: data['marga']['name'],
        birthDate: data['birth_date'] != null
            ? DateTime.parse(data['birth_date'])
            : null,
        deathDate: data['death_date'] != null
            ? DateTime.parse(data['death_date'])
            : null,
        photoUrl: data['photo_url'],
        notes: data['notes'],
      );
    } else {
      throw Exception('Failed to get person details');
    }
  }

  // Get family group
  Future<Map<String, dynamic>> getFamilyGroup(int personId) async {
    final response = await _apiClient.get(
      AppConstants.familyTreeEndpoint,
      queryParameters: {'person_id': personId.toString()},
    );

    if (response.statusCode == 200 && response.data['success']) {
      return response.data['data'];
    } else {
      throw Exception('Failed to get family group');
    }
  }
}
