import 'pokemon_detail_entity.dart';

abstract class PokemonDetailRepository {
  Future<PokemonDetailEntity> getPokemonDetail(String name);
}
