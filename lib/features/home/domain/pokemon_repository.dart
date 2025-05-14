import 'package:pokedex/features/home/domain/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> getPokemons();
}
