import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/utils/string_utils.dart';
import '../domain/pokemon_entity.dart';
import '../domain/pokemon_repository.dart';
import 'pokemon_model.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final http.Client client;

  PokemonRepositoryImpl(this.client);

  @override
  Future<List<PokemonEntity>> getPokemons() async {
    final response = await client
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load pokemons');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    // Obtener los detalles completos para cada Pokémon
    final enrichedResults = await Future.wait(results.map((e) async {
      final pokemonData = await client
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${e['name']}'));

      if (pokemonData.statusCode != 200) {
        throw Exception('Failed to load pokemon details for ${e['name']}');
      }

      final pokemon = json.decode(pokemonData.body);

      final speciesData = await client
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${pokemon['id']}'));

      if (speciesData.statusCode != 200) {
        throw Exception('Failed to load species data for ${e['name']}');
      }

      final species = json.decode(speciesData.body);

      return {
        'number': '#${pokemon['id'].toString().padLeft(3, '0')}',
        'name': pokemon['name'].toString().capitalize(),
        'imageUrl': pokemon['sprites']['other']['official-artwork']
            ['front_default'],
        'types': (pokemon['types'] as List)
            .map((type) => type['type']['name'].toString().capitalize())
            .toList(),
        'color': species['color']['name'], // aquí está el cambio importante
      };
    }));

    return enrichedResults.map((e) => PokemonModel.fromJson(e)).toList();
  }
}
