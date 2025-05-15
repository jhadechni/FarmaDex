import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import '../domain/pokemon_entity.dart';
import '../domain/pokemon_repository.dart';
import 'pokemon_model.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final http.Client client;

  PokemonRepositoryImpl(this.client);

  @override
  Future<List<PokemonEntity>> getPokemons({int offset = 0, int limit = 6}) async {
    final response = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load pokemons');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    final enrichedResults = await Future.wait(
      results.map((e) async {
        try {
          final pokemonRes = await client.get(
            Uri.parse('https://pokeapi.co/api/v2/pokemon/${e['name']}'),
          );

          if (pokemonRes.statusCode != 200) return null;

          final pokemon = json.decode(pokemonRes.body);

          final speciesUrl = pokemon['species']['url'];
          final speciesRes = await client.get(Uri.parse(speciesUrl));

          if (speciesRes.statusCode != 200) return null;

          final species = json.decode(speciesRes.body);

          final name = pokemon['name'];
          final imageUrl = pokemon['sprites']['other']['official-artwork']['front_default'];
          final color = species['color']['name'];
          final types = (pokemon['types'] as List)
              .map((type) => type['type']['name'].toString().capitalize())
              .toList();

          // Validación de campos requeridos
          if (name == null || imageUrl == null || color == null || types.isEmpty) {
            return null;
          }

          return {
            'number': '#${pokemon['id'].toString().padLeft(3, '0')}',
            'name': name.toString().capitalize(),
            'imageUrl': imageUrl,
            'types': types,
            'color': color,
          };
        } catch (e) {
          logError('Error fetching/enriching: $e');
          return null;
        }
      }),
    );

    // Filtrar nulos y mapear a modelo
    return enrichedResults
        .where((e) => e != null)
        .map((e) => PokemonModel.fromJson(e!))
        .toList();
  }
  @override
Future<PokemonEntity> getPokemonDetail(String name) async {
  final response = await client.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch detail for $name');
  }

  final data = json.decode(response.body);
  final speciesRes = await client.get(Uri.parse(data['species']['url']));
  if (speciesRes.statusCode != 200) {
    throw Exception('Failed to fetch species for $name');
  }

  final species = json.decode(speciesRes.body);

  return PokemonModel.fromJson({
    'number': '#${data['id'].toString().padLeft(3, '0')}',
    'name': data['name'].toString().capitalize(),
    'imageUrl': data['sprites']['other']['official-artwork']['front_default'],
    'types': (data['types'] as List)
        .map((type) => type['type']['name'].toString().capitalize())
        .toList(),
    'color': species['color']['name'],
  });
}

@override
Future<List<String>> getAllPokemonNames() async {
  final response = await client.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch all names');
  }

  final data = json.decode(response.body);
  return (data['results'] as List)
      .map((item) => item['name'].toString().toLowerCase())
      .toList();
}

}
