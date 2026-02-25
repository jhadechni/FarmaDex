import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';

abstract class FavoritesRepository {
  List<String> getFavoriteNames();
  List<PokemonDetailEntity> getFavoritePokemons();
  bool isFavorite(String name);
  Future<void> toggle(String name);
}
