import 'package:flutter/material.dart';
import 'package:pokedex/core/widgets/evolution_item.dart';

class EvolutionTab extends StatelessWidget {
  const EvolutionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Evolutions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        _buildEvolutionRow(
          from: const EvolutionItem(
            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
            name: 'Igglybuff',
            number: '174',
          ),
          to: const EvolutionItem(
            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
            name: 'Jigglypuff',
            number: '039',
          ),
          condition: 'High Friendship',
        ),

        const SizedBox(height: 30),

        _buildEvolutionRow(
          from: const EvolutionItem(
            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
            name: 'Jigglypuff',
            number: '039',
          ),
          to: const EvolutionItem(
            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
            name: 'Wigglytuff',
            number: '040',
          ),
          condition: 'Use Moon Stone',
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
