import 'package:flutter/material.dart';
import 'pokeball_logo.dart';

class MiniPokemonCard extends StatelessWidget {
  final String pokemonName;
  final String pokemonNumber;
  final List<String> types;
  final String imagePath;
  final String color;

  const MiniPokemonCard({
    super.key,
    required this.pokemonName,
    required this.pokemonNumber,
    required this.types,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mapColor(color),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // pokeball logo
          Positioned(
            bottom: -10,
            right: -10,
            child: PokeballLogo(
              size: 100,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              imagePath,
              height: 90,
              fit: BoxFit.contain,
              //if error, show default image
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png',
                  height: 90,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),

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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                for (final type in types)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: TypeChip(label: type),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color mapColor(String color) {
  switch (color.toLowerCase()) {
    case 'green':
      return const Color.fromARGB(255, 15, 175, 138);
    case 'red':
      return const Color.fromARGB(255, 201, 16, 16);
    case 'blue':
      return const Color.fromARGB(255, 13, 119, 206);
    case 'yellow':
      return const Color.fromRGBO(255, 206, 74, 1);
    case 'purple':
      return const Color(0xFFBA68C8);
    case 'brown':
      return const Color.fromARGB(255, 136, 115, 107);
    case 'gray':
      return const Color.fromARGB(255, 124, 124, 124);
    case 'black':
      return const Color(0xFF424242);
    case 'pink':
      return const Color(0xFFF48FB1);
    case 'white':
      return const Color.fromARGB(255, 122, 122, 122);
    default:
      return Colors.grey;
  }
}
class TypeChip extends StatelessWidget {
  final String label;

  const TypeChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
