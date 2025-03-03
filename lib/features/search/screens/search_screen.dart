import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarombo/features/auth/providers/auth_provider.dart';
import 'package:tarombo/features/search/providers/search_provider.dart';
import 'package:tarombo/widgets/person_card.dart';
import 'package:tarombo/config/router/routes.dart';
import 'package:intl/intl.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLinkingPerson = false;
  String? _linkingError;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _linkPersonRecord(int personId) async {
    setState(() {
      _isLinkingPerson = true;
      _linkingError = null;
    });

    try {
      final success =
          await ref.read(authStateProvider.notifier).linkPersonRecord(personId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data diri berhasil dihubungkan')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        setState(() {
          _linkingError = 'Gagal menghubungkan data diri. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _linkingError = e.toString();
      });
    } finally {
      setState(() {
        _isLinkingPerson = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Data Silsilah'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).searchPeople(value);
              },
            ),
          ),

          // Linking error message
          if (_linkingError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _linkingError!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            ),

          // Results
          Expanded(
            child: Builder(
              builder: (context) {
                // Initial state - show search prompt
                if (searchState.query.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Cari silsilah keluarga Anda',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Masukkan nama untuk mencari data',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Loading state
                if (searchState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (searchState.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Terjadi kesalahan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          searchState.errorMessage!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Empty results
                if (searchState.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada hasil ditemukan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada hasil untuk "${searchState.query}"',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Show results
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: searchState.results.length,
                  itemBuilder: (context, index) {
                    final person = searchState.results[index];

                    return PersonCard(
                      name: person.fullName,
                      gender: person.gender,
                      marga: person.marga ?? '',
                      birthDate: person.birthDate != null
                          ? DateFormat('d MMMM y').format(person.birthDate!)
                          : null,
                      photoUrl: person.photoUrl,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/person/${person.id}',
                        );
                      },
                      actions: [
                        // If user has no linked person or different person, show link button
                        if (user != null &&
                            (user.personId == null ||
                                user.personId != person.id))
                          IconButton(
                            icon: _isLinkingPerson
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.link),
                            tooltip: 'Hubungkan data',
                            onPressed: _isLinkingPerson
                                ? null
                                : () => _linkPersonRecord(person.id),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
