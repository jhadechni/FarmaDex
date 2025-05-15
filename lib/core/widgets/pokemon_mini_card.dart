import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/color_mapper.dart';
import 'package:pokedex/core/widgets/type_chips.dart';
import 'pokeball_logo.dart';

class MiniPokemonCard extends StatelessWidget {
  final String pokemonName;
  final String pokemonNumber;
  final List<String> types;
  final String imagePath;
  final String color;
  final VoidCallback onTap;

  const MiniPokemonCard({
    super.key,
    required this.pokemonName,
    required this.pokemonNumber,
    required this.types,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: color.toColor(),
          ),
          child: Stack(
            children: [
              // Pokébola decorativa
              Positioned(
                bottom: -10,
                right: -10,
                child: PokeballLogo(
                  size: 100,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
      
              // Imagen del Pokémon
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.network(
                  imagePath,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png',
                      height: 90,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
      
              // Contenido textual
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        pokemonNumber,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pokemonName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: TypeChipList(types: types, isVertical: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

