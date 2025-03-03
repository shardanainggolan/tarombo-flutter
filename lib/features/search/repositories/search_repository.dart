import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/core/api/api_client.dart';
import 'package:tarombo/features/search/models/search_result.dart';
import 'package:tarombo/config/constants.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SearchRepository(apiClient);
});

class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository(this._apiClient);

  Future<List<SearchResult>> searchPeople({
    required String query,
    int? margaId,
    String? gender,
    int limit = 20,
  }) async {
    final queryParams = {
      'query': query,
      if (margaId != null) 'marga_id': margaId.toString(),
      if (gender != null) 'gender': gender,
      'limit': limit.toString(),
    };

    final response = await _apiClient.get(
      AppConstants.searchEndpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data['success']) {
      final results = response.data['data'] as List;
      return results
          .map((item) => SearchResult(
                id: item['id'],
                firstName: item['first_name'],
                lastName: item['last_name'],
                gender: item['gender'],
                marga: item['marga'],
                birthDate: item['birth_date'] != null
                    ? DateTime.parse(item['birth_date'])
                    : null,
                photoUrl: item['photo_url'],
              ))
          .toList();
    } else {
      throw Exception('Search failed');
    }
  }
}
