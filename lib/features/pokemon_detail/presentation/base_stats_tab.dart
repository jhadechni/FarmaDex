import 'package:flutter/material.dart';
import 'package:pokedex/core/widgets/stat_bar.dart';

class BaseStatsTab extends StatelessWidget {
  const BaseStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats
          StatBar(label: 'HP', value: 140, maxValue: 255),
          SizedBox(height: 12),
          StatBar(label: 'Attack', value: 49, maxValue: 255),
          SizedBox(height: 12),
          StatBar(label: 'Defense', value: 49, maxValue: 255),
          SizedBox(height: 12),
          StatBar(label: 'Sp. Atk', value: 65, maxValue: 255),
          SizedBox(height: 12),
          StatBar(label: 'Sp. Def', value: 65, maxValue: 255),
          SizedBox(height: 12),
          StatBar(label: 'Speed', value: 45, maxValue: 255),
          SizedBox(height: 16),
          StatBar(label: 'Total', value: 170, maxValue: 750),

          SizedBox(height: 32),

          // Type Defenses
          Text(
            'Type Defenses',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The effectiveness of each type on this Pokémon. '
            'This can change depending on form, abilities, or items.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Encounter Locations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          StatBar(label: 'Virdian Forest', value: 100, maxValue: 100,
              hasPercentage: true),
          SizedBox(height: 10),
          StatBar(label: 'Virdian Forest', value: 10, maxValue: 100,hasPercentage: true),
          SizedBox(height: 10),
          StatBar(label: 'Virdian Forest', value: 3, maxValue: 100,hasPercentage: true),
          SizedBox(height: 10),
          StatBar(label: 'Virdian Forest', value: 40, maxValue: 100,hasPercentage: true),
          SizedBox(height: 10),
          StatBar(label: 'Virdian Forest', value: 22, maxValue: 100,hasPercentage: true),
        ],
      ),
    );
  }
}
