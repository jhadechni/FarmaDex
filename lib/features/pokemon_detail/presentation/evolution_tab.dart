import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/widgets/evolution_item.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';

class EvolutionTab extends StatelessWidget {
  const EvolutionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final evolutions = context.watch<PokemonDetailViewModel>().pokemonDetail!.evolutions;
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Evolutions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        for (int i = 0; i < evolutions.length - 1; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: _buildEvolutionRow(
              context: context,
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
              screenWidth: screenWidth,
            ),
          ),
      ],
    );
  }

  Widget _buildEvolutionRow({
    required BuildContext context,
    required EvolutionItem from,
    required EvolutionItem to,
    required String condition,
    required double screenWidth,
  }) {
    final isSmallScreen = screenWidth < 400;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(child: from),
        Column(
          children: [
            Icon(Icons.arrow_forward, size: isSmallScreen ? 18 : 24),
            const SizedBox(height: 4),
            Text(
              condition,
              style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Flexible(child: to),
      ],
    );
  }
}
