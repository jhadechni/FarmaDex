import 'package:hive/hive.dart';
import 'package:pokedex/features/pokemon_detail/data/evolution_model.dart';

part 'cached_evolution.g.dart';

@HiveType(typeId: 2)
class CachedEvolution {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String number;

  @HiveField(2)
  final String gifUrl;

  @HiveField(3)
  final String condition;

  CachedEvolution({
    required this.name,
    required this.number,
    required this.gifUrl,
    required this.condition,
  });

  EvolutionModel toModel() => EvolutionModel(
        name: name,
        number: number,
        gifUrl: gifUrl,
        condition: condition,
      );

  factory CachedEvolution.fromModel(EvolutionModel model) => CachedEvolution(
        name: model.name,
        number: model.number,
        gifUrl: model.gifUrl,
        condition: model.condition,
      );
}
