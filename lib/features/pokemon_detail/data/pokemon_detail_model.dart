import 'package:pokedex/features/pokemon_detail/data/move_model.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';
import '../../../core/cache/adapters/cached_evolution.dart';
import '../../../core/cache/adapters/cached_move.dart';
import '../../../core/cache/adapters/cached_pokemon_detail.dart';
import 'evolution_model.dart';

class PokemonDetailModel extends PokemonDetailEntity {
  PokemonDetailModel({
    required super.name,
    required super.number,
    required super.types,
    required super.color,
    required super.specie,
    required super.imageUrl,
    required super.height,
    required super.weight,
    required super.abilities,
    required super.description,
    required super.moves,
    required super.encounterAreas,
    required super.evolutions,
    required super.stats,
    required super.maleRate,
    required super.femaleRate,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      name: json['name'],
      number: json['number'],
      types: List<String>.from(json['types']),
      color: json['color'],
      specie: json['specie'],
      imageUrl: json['imageUrl'],
      height: json['height'],
      weight: json['weight'],
      abilities: List<String>.from(json['abilities']),
      description: json['description'],
      moves: (json['moves'] as List).map((m) => MoveModel.fromJson(m)).toList(),
      encounterAreas: List<String>.from(json['encounterAreas']),
      evolutions: (json['evolutions'] as List)
          .map((e) => EvolutionModel.fromJson(e))
          .toList(),
      stats: Map<String, int>.from(json['stats']),
      maleRate: (json['maleRate'] ?? 0).toDouble(),
      femaleRate: (json['femaleRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'types': types,
      'color': color,
      'specie': specie,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
      'abilities': abilities,
      'description': description,
      'moves': moves.map((m) => (m as MoveModel).toJson()).toList(),
      'encounterAreas': encounterAreas,
      'evolutions': evolutions.map((e) => (e as EvolutionModel).toJson()).toList(),
      'stats': stats,
      'maleRate': maleRate,
      'femaleRate': femaleRate,
    };
  }

  CachedPokemonDetail toCache() {
    return CachedPokemonDetail(
      name: name,
      number: number,
      types: types,
      color: color,
      specie: specie,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      abilities: abilities,
      description: description,
      moves: moves.map((m) => CachedMove.fromModel(m as MoveModel)).toList(),
      encounterAreas: encounterAreas,
      evolutions: evolutions.map((e) => CachedEvolution.fromModel(e as EvolutionModel)).toList(),
      stats: stats,
      maleRate: maleRate,
      femaleRate: femaleRate,
    );
  }
}
