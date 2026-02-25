import 'package:pokedex/features/home/domain/pokemon_entity.dart';
import 'package:pokedex/features/pokemon_detail/domain/evolution_entity.dart';
import 'package:pokedex/features/pokemon_detail/domain/move_entity.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';

PokemonEntity makePokemonEntity({
  String number = '#001',
  String name = 'Bulbasaur',
  String imageUrl = 'https://example.com/bulbasaur.png',
  List<String> types = const <String>['grass', 'poison'],
  String color = 'green',
}) {
  return PokemonEntity(number, name, imageUrl, types, color);
}

MoveEntity makeMoveEntity({
  String name = 'tackle',
  String type = 'normal',
  String category = 'physical',
  int? power = 40,
  int? accuracy = 100,
  int levelLearnedAt = 1,
}) {
  return MoveEntity(
    name: name,
    type: type,
    category: category,
    power: power,
    accuracy: accuracy,
    levelLearnedAt: levelLearnedAt,
  );
}

EvolutionEntity makeEvolutionEntity({
  String name = 'bulbasaur',
  String number = '#001',
  String gifUrl = 'https://example.com/bulbasaur.gif',
  String condition = 'Level 16',
}) {
  return EvolutionEntity(
    name: name,
    number: number,
    gifUrl: gifUrl,
    condition: condition,
  );
}

PokemonDetailEntity makePokemonDetailEntity({
  String name = 'Bulbasaur',
  String number = '#001',
  List<String> types = const <String>['grass', 'poison'],
  String color = 'green',
  String specie = 'Seed',
  String imageUrl = 'https://example.com/bulbasaur.png',
  String height = '0.7 m',
  String weight = '6.9 kg',
  List<String> abilities = const <String>['overgrow'],
  String description = 'A strange seed was planted on its back at birth.',
  List<MoveEntity>? moves,
  List<String> encounterAreas = const <String>['viridian forest'],
  List<EvolutionEntity>? evolutions,
  Map<String, int> stats = const <String, int>{
    'hp': 45,
    'attack': 49,
    'defense': 49,
    'special-attack': 65,
    'special-defense': 65,
    'speed': 45,
  },
  double maleRate = 87.5,
  double femaleRate = 12.5,
}) {
  return PokemonDetailEntity(
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
    moves: moves ?? <MoveEntity>[makeMoveEntity()],
    encounterAreas: encounterAreas,
    evolutions: evolutions ??
        <EvolutionEntity>[
          makeEvolutionEntity(),
          makeEvolutionEntity(
              name: 'ivysaur', number: '#002', condition: 'Level 32')
        ],
    stats: stats,
    maleRate: maleRate,
    femaleRate: femaleRate,
  );
}
