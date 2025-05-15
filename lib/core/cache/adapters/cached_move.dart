import 'package:hive/hive.dart';
import 'package:pokedex/features/pokemon_detail/data/move_model.dart';

part 'cached_move.g.dart';

@HiveType(typeId: 1)
class CachedMove {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int? power;

  @HiveField(4)
  final int? accuracy;

  @HiveField(5)
  final int levelLearnedAt;

  CachedMove({
    required this.name,
    required this.type,
    required this.category,
    this.power,
    this.accuracy,
    required this.levelLearnedAt,
  });

  MoveModel toModel() => MoveModel(
        name: name,
        type: type,
        category: category,
        power: power,
        accuracy: accuracy,
        levelLearnedAt: levelLearnedAt,
      );

  factory CachedMove.fromModel(MoveModel model) => CachedMove(
        name: model.name,
        type: model.type,
        category: model.category,
        power: model.power,
        accuracy: model.accuracy,
        levelLearnedAt: model.levelLearnedAt,
      );
}
