import 'package:flutter/material.dart';

class TypeChipList extends StatelessWidget {
  final List<String> types;
  final bool isVertical;

  const TypeChipList({
    super.key,
    required this.types,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) => TypeChip(label: type)).toList(),
    );
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
