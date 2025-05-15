

import 'package:pokedex/features/pokemon_detail/domain/move_entity.dart';

class MoveModel extends MoveEntity {
  MoveModel({
    required super.name,
    required super.type,
    required super.category,
    super.power,
    super.accuracy,
    required super.levelLearnedAt,
  });

  factory MoveModel.fromJson(Map<String, dynamic> json) {
    return MoveModel(
      name: json['name'],
      type: json['type'],
      category: json['category'],
      power: json['power'],
      accuracy: json['accuracy'],
      levelLearnedAt: json['levelLearnedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'category': category,
        'power': power,
        'accuracy': accuracy,
        'levelLearnedAt': levelLearnedAt,
      };
}
