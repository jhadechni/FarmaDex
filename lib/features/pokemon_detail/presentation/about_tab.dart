import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/widgets/gender_bar.dart';
import 'package:provider/provider.dart';

import 'pokemon_detail_view_model.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = context.watch<PokemonDetailViewModel>().pokemonDetail!;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 60) / 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            pokemon.description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              InfoGridElement(
                icon: Icons.scale,
                label: 'Weight',
                value: pokemon.weight,
                width: itemWidth,
              ),
              InfoGridElement(
                icon: Icons.height,
                label: 'Height',
                value: pokemon.height,
                width: itemWidth,
              ),
              InfoGridElement(
                icon: Icons.bubble_chart,
                label: 'Abilities',
                value: pokemon.abilities.isNotEmpty
                    ? pokemon.abilities.first.capitalize()
                    : 'Unknown',
                width: itemWidth,
              ),
              InfoGridElement(
                icon: Icons.pets,
                label: 'Species',
                value: pokemon.specie,
                width: itemWidth,
              ),
            ],
          ),
          const SizedBox(height: 20),
          GenderRatioBar(
            malePercentage: pokemon.maleRate,
            femalePercentage: pokemon.femaleRate,
          ),
        ],
      ),
    );
  }
}

class InfoGridElement extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final double width;

  const InfoGridElement({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 18),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
