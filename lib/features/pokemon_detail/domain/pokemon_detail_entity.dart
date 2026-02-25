import 'evolution_entity.dart';
import 'move_entity.dart';

class PokemonDetailEntity {
  final String name;
  final String number;
  final List<String> types;
  final String color;
  final String specie;
  final String imageUrl;
  final String height;
  final String weight;
  final List<String> abilities;
  final String description;
  final List<MoveEntity> moves;
  final List<String> encounterAreas;
  final List<EvolutionEntity> evolutions;
  final Map<String, int> stats;
  final double maleRate;
  final double femaleRate;

  const PokemonDetailEntity({
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
}
