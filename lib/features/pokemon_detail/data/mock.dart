class MockPokemonDetail {
  static const name = 'Bulbasaur';
  static const number = '#001';
  static const types = ['Fire', 'Poison'];
  static const color = 'green';
  static const specie = 'Seed Pokémon';
  static const imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png';

  static const height = '0,70 m';
  static const weight = '0,7 kg';
  static const abilities = ['Overgrow', 'Chlorophyll'];
  static const baseExperience = '64';
  static const description =
      'While it is young, it uses the nutrients that are stored in the seed on its back in order to grow.\n\nThere is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.';
  static List<Move> mockMoves = [
    Move(
        name: 'Vine Whip',
        type: 'Grass',
        category: 'Physical',
        power: 45,
        accuracy: 100,
        levelLearnedAt: 7),
    Move(
        name: 'Growl',
        type: 'Normal',
        category: 'Physical',
        power: null,
        accuracy: 100,
        levelLearnedAt: 1),
  ];
}

class Move {
  final String name;
  final String type;
  final String category;
  final int? power;
  final int? accuracy;
  final int levelLearnedAt;

  Move({
    required this.name,
    required this.type,
    required this.category,
    this.power,
    this.accuracy,
    required this.levelLearnedAt,
  });
}
