import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/result.dart';

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

    final result = await repository.getPokemonDetail(name);

    result.when(
      success: (data) {
        pokemonDetail = data;
      },
      failure: (error) {
        errorMessage = error.message;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
