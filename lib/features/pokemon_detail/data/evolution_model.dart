import '../domain/evolution_entity.dart';

class EvolutionModel extends EvolutionEntity {
  EvolutionModel({
    required super.name,
    required super.number,
    required super.gifUrl,
    required super.condition,
  });

  factory EvolutionModel.fromJson(Map<String, dynamic> json) {
    return EvolutionModel(
      name: json['name'],
      number: json['number'],
      gifUrl: json['gifUrl'],
      condition: json['condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'gifUrl': gifUrl,
      'condition': condition,
    };
  }
}
