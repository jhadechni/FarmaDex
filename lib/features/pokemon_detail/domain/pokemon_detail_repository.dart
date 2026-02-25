import 'package:pokedex/core/utils/result.dart';
import 'pokemon_detail_entity.dart';

abstract class PokemonDetailRepository {
  Future<Result<PokemonDetailEntity>> getPokemonDetail(String name);
}
