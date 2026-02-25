import 'package:pokedex/core/utils/result.dart';
import 'package:pokedex/features/home/domain/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<Result<List<PokemonEntity>>> getPokemons({int offset = 0, int limit = 6});
  Future<Result<PokemonEntity>> getPokemonDetail(String name);
  Future<Result<List<String>>> getAllPokemonNames();
}
