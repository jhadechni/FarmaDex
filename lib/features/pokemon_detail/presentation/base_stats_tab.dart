import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/widgets/stat_bar.dart';
import 'package:pokedex/features/home/data/pokemon_repository_impl.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';

class BaseStatsTab extends StatelessWidget {
  const BaseStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = context.watch<PokemonDetailViewModel>().pokemonDetail!;

    final stats = pokemon.stats;
    final total = stats.values.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatBar(label: 'HP', value: stats['hp'] ?? 0, maxValue: 255),
          const SizedBox(height: 12),
          StatBar(label: 'Attack', value: stats['attack'] ?? 0, maxValue: 255),
          const SizedBox(height: 12),
          StatBar(label: 'Defense', value: stats['defense'] ?? 0, maxValue: 255),
          const SizedBox(height: 12),
          StatBar(label: 'Sp. Atk', value: stats['special-attack'] ?? 0, maxValue: 255),
          const SizedBox(height: 12),
          StatBar(label: 'Sp. Def', value: stats['special-defense'] ?? 0, maxValue: 255),
          const SizedBox(height: 12),
          StatBar(label: 'Speed', value: stats['speed'] ?? 0, maxValue: 255),
          const SizedBox(height: 16),
          StatBar(label: 'Total', value: total, maxValue: 750),
          const SizedBox(height: 32),
          const Text(
            'Encounter Locations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The locations where this Pokémon can be found in the wild.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          if (pokemon.encounterAreas.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'No encounter locations found.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            )
          else
            const SizedBox(height: 12),
          for (final area in pokemon.encounterAreas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StatBar(
                label: area.capitalize(),
                value: 100, // Puedes ajustar a valor real si lo tienes
                maxValue: 100,
                hasPercentage: true,
              ),
            ),
        ],
      ),
    );
  }
}
