import 'package:pokedex/core/utils/result.dart';
import 'package:pokedex/features/favorites/domain/favorites_repository.dart';
import 'package:pokedex/features/home/domain/pokemon_entity.dart';
import 'package:pokedex/features/home/domain/pokemon_repository.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_repository.dart';

class FakePokemonRepository implements PokemonRepository {
  FakePokemonRepository({
    Result<List<PokemonEntity>>? pokemonsResult,
    Result<PokemonEntity>? detailResult,
    Result<List<String>>? allNamesResult,
  })  : pokemonsResult = pokemonsResult ?? const Success(<PokemonEntity>[]),
        detailResult = detailResult ??
            const Failure<PokemonEntity>(
                NotFoundException('Pokemon not found')),
        allNamesResult = allNamesResult ?? const Success(<String>[]);

  Result<List<PokemonEntity>> pokemonsResult;
  Result<PokemonEntity> detailResult;
  Result<List<String>> allNamesResult;

  int getPokemonsCallCount = 0;
  int getPokemonDetailCallCount = 0;
  int getAllPokemonNamesCallCount = 0;

  @override
  Future<Result<List<String>>> getAllPokemonNames() async {
    getAllPokemonNamesCallCount += 1;
    return allNamesResult;
  }

  @override
  Future<Result<PokemonEntity>> getPokemonDetail(String name) async {
    getPokemonDetailCallCount += 1;
    return detailResult;
  }

  @override
  Future<Result<List<PokemonEntity>>> getPokemons({
    int offset = 0,
    int limit = 6,
  }) async {
    getPokemonsCallCount += 1;
    return pokemonsResult;
  }
}

class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({
    List<PokemonDetailEntity>? favorites,
    Map<String, PokemonDetailEntity>? catalogByName,
  })  : _favorites = favorites ?? <PokemonDetailEntity>[],
        _catalogByName = catalogByName ?? <String, PokemonDetailEntity>{};

  final List<PokemonDetailEntity> _favorites;
  final Map<String, PokemonDetailEntity> _catalogByName;

  int toggleCallCount = 0;
  String? lastToggledName;

  @override
  List<String> getFavoriteNames() {
    return _favorites.map((pokemon) => pokemon.name).toList();
  }

  @override
  List<PokemonDetailEntity> getFavoritePokemons() {
    return List<PokemonDetailEntity>.unmodifiable(_favorites);
  }

  @override
  bool isFavorite(String name) {
    return _favorites.any((pokemon) => pokemon.name == name);
  }

  @override
  Future<void> toggle(String name) async {
    toggleCallCount += 1;
    lastToggledName = name;

    final existingIndex =
        _favorites.indexWhere((pokemon) => pokemon.name == name);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
      return;
    }

    final pokemon = _catalogByName[name];
    if (pokemon != null) {
      _favorites.add(pokemon);
    }
  }
}

class FakePokemonDetailRepository implements PokemonDetailRepository {
  FakePokemonDetailRepository({
    Result<PokemonDetailEntity>? detailResult,
  }) : detailResult = detailResult ??
            const Failure<PokemonDetailEntity>(
              NotFoundException('Pokemon not found'),
            );

  Result<PokemonDetailEntity> detailResult;
  int getPokemonDetailCallCount = 0;

  @override
  Future<Result<PokemonDetailEntity>> getPokemonDetail(String name) async {
    getPokemonDetailCallCount += 1;
    return detailResult;
  }
}
