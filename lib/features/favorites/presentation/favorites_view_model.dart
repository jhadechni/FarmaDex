import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';

import '../domain/favorites_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository repository;

  FavoritesViewModel(this.repository);

  List<String> get favoriteNames => repository.getFavoriteNames();

  List<PokemonDetailEntity> get favoritePokemons => repository.getFavoritePokemons();

  bool isFavorite(String name) => repository.isFavorite(name);

  Future<void> toggle(String name) async {
    await repository.toggle(name);
    notifyListeners();
  }
}
