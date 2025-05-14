import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import '../domain/pokemon_entity.dart';
import '../domain/pokemon_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PokemonRepository repository;
  List<PokemonEntity> pokemons = [];
  bool isLoading = true;

  HomeViewModel(this.repository);

  Future<void> fetchPokemons() async {
    isLoading = true;
    notifyListeners();

    try {
      pokemons = await repository.getPokemons();
      logInfo('Pokemons: ${pokemons[0].imageUrl}');
    } catch (e) {
      // Manejo de error si deseas
      logError(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
