import 'package:hive/hive.dart';

part 'registered_pokemon.g.dart';

@HiveType(typeId: 1)
class RegisteredPokemon {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String species;

  @HiveField(2)
  final String height;

  @HiveField(3)
  final String weight;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String imagePath;

  RegisteredPokemon({
    required this.name,
    required this.species,
    required this.height,
    required this.weight,
    required this.gender,
    required this.imagePath,
  });
}
