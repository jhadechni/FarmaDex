import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/color_mapper.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';

class MovesTab extends StatelessWidget {
  const MovesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final moves = context.watch<PokemonDetailViewModel>().pokemonDetail?.moves ?? [];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: moves.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final move = moves[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lado izquierdo: nombre y etiquetas
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      move.name.capitalize(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Chip(label: move.type, color: move.type.toTypeColor()),
                        const SizedBox(width: 8),
                        _Chip(label: move.category, color: move.category.toCategoryColor()),
                      ],
                    ),
                  ],
                ),
              ),
              // Lado derecho: stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Stat(label: 'Power', value: move.power?.toString() ?? '–'),
                  _Stat(label: 'Accuracy', value: move.accuracy?.toString() ?? '–'),
                  _Stat(label: 'Level', value: move.levelLearnedAt.toString()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }
}
