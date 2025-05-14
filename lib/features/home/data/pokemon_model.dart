
import 'package:pokedex/features/home/domain/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel(super.number, super.name, super.imageUrl, super.types, super.color);

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      json['number'],
      json['name'],
      json['imageUrl'],
      json['types'],
      json['color']
    );
  }
}
