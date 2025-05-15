class MoveEntity {
  final String name;
  final String type;
  final String category;
  final int? power;
  final int? accuracy;
  final int levelLearnedAt;

  MoveEntity({
    required this.name,
    required this.type,
    required this.category,
    this.power,
    this.accuracy,
    required this.levelLearnedAt,
  });
}
