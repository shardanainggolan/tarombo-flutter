import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/search/models/search_result.dart';
import 'package:tarombo/features/search/repositories/search_repository.dart';

// Search state
class SearchState {
  final List<SearchResult> results;
  final bool isLoading;
  final String? errorMessage;
  final String query;

  SearchState({
    required this.results,
    this.isLoading = false,
    this.errorMessage,
    this.query = '',
  });

  SearchState copyWith({
    List<SearchResult>? results,
    bool? isLoading,
    String? errorMessage = '',
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Set to null if empty string
      query: query ?? this.query,
    );
  }
}

// Search provider
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;
  Timer? _debounceTimer;

  SearchNotifier(this._repository) : super(SearchState(results: []));

  void searchPeople(String query) {
    // Update query immediately
    state = state.copyWith(query: query);

    // Debounce search requests
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // If query is empty, clear results
    if (query.isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    // Set loading state
    state = state.copyWith(isLoading: true);

    // Debounce to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _repository.searchPeople(query: query);
        state = state.copyWith(results: results, isLoading: false);
      } catch (e) {
        state = state.copyWith(
          results: [],
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    });
  }

  void clearSearch() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    state = SearchState(results: []);
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});
