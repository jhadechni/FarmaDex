import 'package:flutter/material.dart';

import '../domain/pokemon_detail_entity.dart';
import '../domain/pokemon_detail_repository.dart';

class PokemonDetailViewModel extends ChangeNotifier {
  final PokemonDetailRepository repository;

  PokemonDetailViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;

  PokemonDetailEntity? pokemonDetail;

  Future<void> fetchDetail(String name) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getPokemonDetail(name);
      pokemonDetail = result;
    } catch (e) {
      errorMessage = 'Failed to load details: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
