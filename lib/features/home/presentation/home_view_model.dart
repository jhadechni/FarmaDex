import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/utils/result.dart';
import '../domain/pokemon_entity.dart';
import '../domain/pokemon_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PokemonRepository repository;

  List<PokemonEntity> pokemons = [];
  List<String> allPokemonNames = [];
  String _searchQuery = '';
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isFetchingSearch = false;
  int offset = 0;
  bool allLoaded = false;
  final int limit = 10;
  PokemonEntity? searchResult;
  String? errorMessage;

  HomeViewModel(this.repository);

  List<PokemonEntity> get filteredPokemons {
    if (_searchQuery.isEmpty) return pokemons;

    final filtered = pokemons
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (filtered.isEmpty && searchResult != null) {
      return [searchResult!];
    }

    return filtered;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();

    final match = allPokemonNames.firstWhere(
      (n) => n.toLowerCase().contains(_searchQuery.toLowerCase()),
      orElse: () => '',
    );

    if (_searchQuery.isNotEmpty &&
        match.isNotEmpty &&
        !pokemons.any((p) => p.name.toLowerCase() == match.toLowerCase())) {
      Future.microtask(() => fetchDetailAndAdd(match));
    }
  }

  Future<void> fetchInitialPokemons() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    offset = 0;
    allLoaded = false;

    final result = await repository.getPokemons(offset: offset, limit: limit);

    result.when(
      success: (data) {
        pokemons = data;
        offset += limit;
        logInfo('Loaded ${pokemons.length} pokemons');
      },
      failure: (error) {
        errorMessage = error.message;
        logError('Initial fetch error: $error');
      },
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePokemons() async {
    if (isLoadingMore || allLoaded) return;

    isLoadingMore = true;
    notifyListeners();

    final result = await repository.getPokemons(offset: offset, limit: limit);

    result.when(
      success: (newPokemons) {
        if (newPokemons.isEmpty) {
          allLoaded = true;
          logInfo('All pokemons loaded');
        } else {
          pokemons.addAll(newPokemons);
          offset += limit;
          logInfo('Fetched more. Total: ${pokemons.length}');
        }
      },
      failure: (error) {
        logError('Fetch more error: $error');
      },
    );

    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> fetchAllPokemonNames() async {
    final result = await repository.getAllPokemonNames();

    result.when(
      success: (names) {
        allPokemonNames = names;
        logInfo('Fetched ${allPokemonNames.length} pokemon names');
      },
      failure: (error) {
        logError('Failed to fetch all names: $error');
      },
    );
  }

  Future<void> fetchDetailAndAdd(String name) async {
    isFetchingSearch = true;
    notifyListeners();

    final result = await repository.getPokemonDetail(name);

    result.when(
      success: (detail) {
        searchResult = detail;
        logInfo('Fetched detail for $name');
      },
      failure: (error) {
        logError('Error fetching detail for $name: $error');
      },
    );

    isFetchingSearch = false;
    notifyListeners();
  }
}
