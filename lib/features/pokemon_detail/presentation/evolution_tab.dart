import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/widgets/evolution_item.dart';
import 'package:pokedex/features/home/data/pokemon_repository_impl.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';

class EvolutionTab extends StatelessWidget {
  const EvolutionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final evolutions = context.watch<PokemonDetailViewModel>().pokemonDetail!.evolutions;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Evolutions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        for (int i = 0; i < evolutions.length - 1; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: _buildEvolutionRow(
              from: EvolutionItem(
                imageUrl: evolutions[i].gifUrl,
                name: evolutions[i].name.capitalize(),
                number: evolutions[i].number,
              ),
              to: EvolutionItem(
                imageUrl: evolutions[i + 1].gifUrl,
                name: evolutions[i + 1].name.capitalize(),
                number: evolutions[i + 1].number,
              ),
              condition: evolutions[i + 1].condition,
            ),
          ),
          
      ],
    );
  }

  Widget _buildEvolutionRow({
    required EvolutionItem from,
    required EvolutionItem to,
    required String condition,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        from,
        Column(
          children: [
            const Icon(Icons.arrow_forward, size: 24),
            const SizedBox(height: 4),
            Text(condition, style: const TextStyle(fontSize: 12)),
          ],
        ),
        to,
      ],
    );
  }
}
