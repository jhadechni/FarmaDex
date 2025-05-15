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
  });
}

class MoveEntity {
  final String name;
  final String type;
  final String category;
  final int? power;
  final int? accuracy;
  final int levelLearnedAt;

  const MoveEntity({
    required this.name,
    required this.type,
    required this.category,
    this.power,
    this.accuracy,
    required this.levelLearnedAt,
  });
}
