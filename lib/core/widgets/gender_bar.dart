import 'package:flutter/material.dart';

class GenderRatioBar extends StatelessWidget {
  final double malePercentage;
  final double femalePercentage;
  const GenderRatioBar({
    super.key,
    required this.malePercentage,
    required this.femalePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final maleRatio = malePercentage / 100;
    final femaleRatio = femalePercentage / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'GENDER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                flex: (maleRatio * 1000).toInt(), // mantener precisión
                child: Container(height: 10, color: Colors.blue[700]),
              ),
              Expanded(
                flex: (femaleRatio * 1000).toInt(),
                child: Container(height: 10, color: Colors.pinkAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.male, color: Colors.blue, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${malePercentage.toStringAsFixed(1).replaceAll('.', ',')}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.female, color: Colors.pink, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${femalePercentage.toStringAsFixed(1).replaceAll('.', ',')}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
