import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:pokedex/features/pokemon_detail/data/move_model.dart';
import 'package:pokedex/features/pokemon_detail/data/pokemon_detail_model.dart';
import '../domain/pokemon_detail_repository.dart';
import 'evolution_model.dart';

class PokemonDetailRepositoryImpl implements PokemonDetailRepository {
  final http.Client client;

  PokemonDetailRepositoryImpl(this.client);

  @override
  Future<PokemonDetailModel> getPokemonDetail(String name) async {
    final pokemonRes =
        await client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
    if (pokemonRes.statusCode != 200) {
      throw Exception('Failed to fetch pokemon detail');
    }
    final data = json.decode(pokemonRes.body);

    // species
    final speciesRes = await client.get(Uri.parse(data['species']['url']));
    final speciesData = json.decode(speciesRes.body);

    // description
    final flavor = (speciesData['flavor_text_entries'] as List).firstWhere(
      (entry) => entry['language']['name'] == 'en',
      orElse: () => {'flavor_text': ''},
    );

    // encounter areas
    final encountersRes =
        await client.get(Uri.parse(data['location_area_encounters']));
    final encounterData = json.decode(encountersRes.body);
    final areas = (encounterData as List)
        .map((e) => e['location_area']['name'].toString().replaceAll('-', ' '))
        .toList();

    // evolutions
    final evolutionChainUrl = speciesData['evolution_chain']['url'];
    final evoRes = await client.get(Uri.parse(evolutionChainUrl));
    final evoData = json.decode(evoRes.body);
    final evolutions = <EvolutionModel>[];

    // stats
    final statsMap = <String, int>{};
    for (var stat in data['stats']) {
      statsMap[stat['stat']['name']] = stat['base_stat'];
    }

// gender
    final genderRate = speciesData['gender_rate'];
    final male = genderRate == -1 ? 0.0 : (8 - genderRate) * 12.5;
    final female = genderRate == -1 ? 0.0 : genderRate * 12.5;

    void traverse(Map<String, dynamic> chain) {
      final species = chain['species'];
      final speciesId = _extractIdFromUrl(species['url']);

      evolutions.add(EvolutionModel(
        name: species['name'],
        number: '#${speciesId.padLeft(3, '0')}',
        gifUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$speciesId.gif',
        condition: chain['evolution_details'] != null &&
                chain['evolution_details'].isNotEmpty
            ? _parseEvolutionCondition(chain['evolution_details'][0])
            : 'Base',
      ));

      if (chain['evolves_to'] != null && chain['evolves_to'].isNotEmpty) {
        traverse(chain['evolves_to'][0]);
      }
    }

    traverse(evoData['chain']);
    logDebug('Evolutions: ${evolutions.map((e) => {e.name,e.number,e.condition,e.gifUrl}).toList()}');
    // moves with detail
    final moveModels = <MoveModel>[];
    for (final move in data['moves']) {
      final versionDetails = move['version_group_details'] as List;
      final learned = versionDetails.firstWhere(
        (v) => v['move_learn_method']['name'] == 'level-up',
        orElse: () => null,
      );
      if (learned == null) continue;

      final moveDetailRes = await client.get(Uri.parse(move['move']['url']));
      final moveDetail = json.decode(moveDetailRes.body);

      moveModels.add(MoveModel(
        name: move['move']['name'],
        type: moveDetail['type']['name'],
        category: moveDetail['damage_class']['name'],
        power: moveDetail['power'],
        accuracy: moveDetail['accuracy'],
        levelLearnedAt: learned['level_learned_at'],
      ));
    }

    return PokemonDetailModel(
      name: data['name'],
      number: '#${data['id'].toString().padLeft(3, '0')}',
      types: List<String>.from(
          (data['types'] ?? []).map((t) => t['type']['name'])),
      color: speciesData['color']['name'],
      specie: speciesData['genera'].firstWhere(
              (g) => g['language']['name'] == 'en',
              orElse: () => {'genus': 'Unknown'})['genus'] ??
          'Unknown',
      imageUrl: data['sprites']['other']['official-artwork']['front_default'],
      height: '${(data['height'] / 10).toStringAsFixed(2)} m',
      weight: '${(data['weight'] / 10).toStringAsFixed(2)} kg',
      abilities: List<String>.from(
          (data['abilities'] ?? []).map((a) => a['ability']['name'])),
      description: flavor['flavor_text'].toString().replaceAll('\n', ' '),
      moves: moveModels,
      encounterAreas: areas,
      evolutions: evolutions,
      stats: statsMap,
      maleRate: male,
      femaleRate: female
    );
  }
}

String _extractIdFromUrl(String url) {
  final segments = url.split('/');
  return segments[segments.length - 2]; // penúltimo segmento es el ID
}

String _parseEvolutionCondition(Map<String, dynamic> details) {
  if (details['min_level'] != null) {
    return 'Level ${details['min_level']}';
  }

  if (details['trigger']?['name'] == 'use-item') {
    final item = details['item']?['name'];
    return item != null ? 'Use $item' : 'Use item';
  }

  if (details['trigger']?['name'] == 'trade') {
    return 'Trade';
  }

  if (details['min_happiness'] != null) {
    return 'High Friendship';
  }

  if (details['min_beauty'] != null) {
    return 'High Beauty';
  }

  if (details['min_affection'] != null) {
    return 'High Affection';
  }

  if (details['held_item'] != null) {
    return 'Hold ${details['held_item']['name']}';
  }

  if (details['location'] != null) {
    return 'At ${details['location']['name']}';
  }

  return 'Special Condition';
}
