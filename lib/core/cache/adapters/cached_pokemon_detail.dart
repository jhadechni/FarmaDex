// lib/core/cache/models/cached_pokemon_detail.dart


import 'package:hive/hive.dart';
import 'package:pokedex/core/cache/adapters/cached_evolution.dart';
import 'package:pokedex/core/cache/adapters/cached_move.dart';

import '../../../features/pokemon_detail/data/pokemon_detail_model.dart';

part 'cached_pokemon_detail.g.dart';

@HiveType(typeId: 0)
class CachedPokemonDetail {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String number;

  @HiveField(2)
  final List<String> types;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final String specie;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final String height;

  @HiveField(7)
  final String weight;

  @HiveField(8)
  final List<String> abilities;

  @HiveField(9)
  final String description;

  @HiveField(10)
  final List<CachedMove> moves;

  @HiveField(11)
  final List<String> encounterAreas;

  @HiveField(12)
  final List<CachedEvolution> evolutions;

  @HiveField(13)
  final Map<String, int> stats;

  @HiveField(14)
  final double maleRate;

  @HiveField(15)
  final double femaleRate;

  CachedPokemonDetail({
    required this.name,
    required this.number,
    required this.types,
    required this.color,
    required this.specie,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.description,
    required this.moves,
    required this.encounterAreas,
    required this.evolutions,
    required this.stats,
    required this.maleRate,
    required this.femaleRate,
  });


  PokemonDetailModel toModel() {
    return PokemonDetailModel(
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
      moves: moves.map((m) => m.toModel()).toList(),
      encounterAreas: encounterAreas,
      evolutions: evolutions.map((e) => e.toModel()).toList(),
      stats: stats,
      maleRate: maleRate,
      femaleRate: femaleRate,
    );
  }
}
