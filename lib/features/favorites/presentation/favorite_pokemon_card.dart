import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/utils/color_mapper.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';
import 'package:pokedex/core/widgets/type_chips.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoritePokemonCard extends StatelessWidget {
  final PokemonDetailEntity pokemon;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FavoritePokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(pokemon.name),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pokemon.color.toColor().withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.number,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pokemon.name.capitalize(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 8),
                    TypeChipList(types: pokemon.types, isVertical: false),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: pokemon.color.toColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      pokemon.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.pinkAccent,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}