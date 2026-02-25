import 'package:hive/hive.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';

import '../domain/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  static const _favoritesBoxName = 'favorites_box';
  static const _cacheBoxName = 'pokemon_detail_cache';

  late final Box<String> _favoritesBox;
  late final Box<CachedPokemonDetail> _cacheBox;

  FavoritesRepositoryImpl() {
    _favoritesBox = Hive.box<String>(_favoritesBoxName);
    _cacheBox = Hive.box<CachedPokemonDetail>(_cacheBoxName);
  }

  @override
  List<String> getFavoriteNames() => _favoritesBox.values.toList();

  @override
  List<PokemonDetailEntity> getFavoritePokemons() {
    return _favoritesBox.values
        .map((name) => _cacheBox.get(name))
        .whereType<CachedPokemonDetail>()
        .map((cached) => cached.toModel())
        .toList();
  }

  @override
  bool isFavorite(String name) => _favoritesBox.containsKey(name);

  @override
  Future<void> toggle(String name) async {
    final key = name.capitalize();
    if (_favoritesBox.containsKey(key)) {
      await _favoritesBox.delete(key);
    } else {
      await _favoritesBox.put(key, key);
    }
  }
}
