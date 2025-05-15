import 'package:pokedex/features/home/domain/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> getPokemons({int offset = 0, int limit = 6});
   Future<PokemonEntity> getPokemonDetail(String name);
  Future<List<String>> getAllPokemonNames();
}
