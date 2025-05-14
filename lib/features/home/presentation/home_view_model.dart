import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import '../domain/pokemon_entity.dart';
import '../domain/pokemon_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PokemonRepository repository;

  List<PokemonEntity> pokemons = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0;
  bool allLoaded = false;
  final int limit = 10;

  HomeViewModel(this.repository);

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
}

