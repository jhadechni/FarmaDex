import 'package:flutter/material.dart';

extension ColorMapperExtension on String {
  Color toColor() {
    switch (toLowerCase()) {
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
        return const Color.fromARGB(
            255, 120, 120, 120); // Fixed to actual white
      default:
        return Colors.grey;
    }
  }
}

extension CategoryColorMapperExtension on String {
  Color toCategoryColor() {
    switch (toLowerCase()) {
      case 'physical':
        return Colors.orange;
      case 'special':
        return Colors.indigo;
      case 'status':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}

extension TypeColorMapperExtension on String {
  Color toTypeColor() {
    switch (toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'normal':
        return Colors.grey;
      case 'poison':
        return Colors.purple;
      case 'electric':
        return Colors.amber;
      default:
        return Colors.teal;
    }
  }
}