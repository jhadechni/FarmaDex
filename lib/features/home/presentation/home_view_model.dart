import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
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


  HomeViewModel(this.repository);

  List<PokemonEntity> get filteredPokemons {
  if (_searchQuery.isEmpty) return pokemons;

  final filtered = pokemons
      .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  // No mezcles con pokemons cargados si hay uno específicamente buscado
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
      // Defer fetch until after build
      Future.microtask(() => fetchDetailAndAdd(match));
    }
  }

  Future<void> fetchInitialPokemons() async {
    isLoading = true;
    notifyListeners();

    try {
      offset = 0;
      allLoaded = false;
      pokemons = await repository.getPokemons(offset: offset, limit: limit);
      offset += limit;
      logInfo('Loaded ${pokemons.length} pokemons');
    } catch (e) {
      logError('Initial fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePokemons() async {
    if (isLoadingMore || allLoaded) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final newPokemons = await repository.getPokemons(offset: offset, limit: limit);
      if (newPokemons.isEmpty) {
        allLoaded = true;
        logInfo('All pokemons loaded');
      } else {
        pokemons.addAll(newPokemons);
        offset += limit;
        logInfo('Fetched more. Total: ${pokemons.length}');
      }
    } catch (e) {
      logError('Fetch more error: $e');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllPokemonNames() async {
    try {
      final res = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10000'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        allPokemonNames = List<String>.from(data['results'].map((e) => e['name']));
        logInfo('Fetched ${allPokemonNames.length} pokemon names');
      }
    } catch (e) {
      logError('Failed to fetch all names: $e');
    }
  }

  Future<void> fetchDetailAndAdd(String name) async {
  isFetchingSearch = true;
  notifyListeners();

  try {
    final detail = await repository.getPokemonDetail(name);
    searchResult = detail;
    logInfo('Fetched detail for $name');
  } catch (e) {
    logError('Error fetching detail for $name: $e');
  } finally {
    isFetchingSearch = false;
    notifyListeners();
  }
}

}
