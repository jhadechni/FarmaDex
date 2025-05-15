import 'package:flutter/material.dart';
import 'package:pokedex/core/widgets/pokeball_logo.dart';

class EvolutionItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String number;

  const EvolutionItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Aumentamos el tamaño base
    final avatarSize = screenWidth < 400 ? 50.0 : 65.0;
    final logoSize = avatarSize * 1.7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: logoSize,
          height: logoSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PokeballLogo(size: logoSize, color: Colors.grey.shade200),
              CircleAvatar(
                radius: avatarSize * 0.5,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          number,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
