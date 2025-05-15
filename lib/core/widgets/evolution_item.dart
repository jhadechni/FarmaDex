import 'package:flutter/material.dart';

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
    final imageSize = screenWidth < 400 ? 60.0 : 100.0;

    return Column(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          number,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
