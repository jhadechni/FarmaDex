import 'package:flutter/material.dart';

/// Enum representing all Pokémon types with their associated colors.
///
/// This provides type safety instead of using raw strings for types.
enum PokemonType {
  normal('Normal', Color(0xFFA8A878)),
  fire('Fire', Color(0xFFF08030)),
  water('Water', Color(0xFF6890F0)),
  electric('Electric', Color(0xFFF8D030)),
  grass('Grass', Color(0xFF78C850)),
  ice('Ice', Color(0xFF98D8D8)),
  fighting('Fighting', Color(0xFFC03028)),
  poison('Poison', Color(0xFFA040A0)),
  ground('Ground', Color(0xFFE0C068)),
  flying('Flying', Color(0xFFA890F0)),
  psychic('Psychic', Color(0xFFF85888)),
  bug('Bug', Color(0xFFA8B820)),
  rock('Rock', Color(0xFFB8A038)),
  ghost('Ghost', Color(0xFF705898)),
  dragon('Dragon', Color(0xFF7038F8)),
  dark('Dark', Color(0xFF705848)),
  steel('Steel', Color(0xFFB8B8D0)),
  fairy('Fairy', Color(0xFFEE99AC)),
  unknown('Unknown', Color(0xFF68A090));

  final String displayName;
  final Color color;

  const PokemonType(this.displayName, this.color);

  /// Parses a string to PokemonType.
  /// Returns [PokemonType.unknown] if the type is not recognized.
  static PokemonType fromString(String type) {
    final normalized = type.toLowerCase().trim();
    return PokemonType.values.firstWhere(
      (t) => t.name == normalized,
      orElse: () => PokemonType.unknown,
    );
  }

  /// Converts a list of type strings to PokemonType list.
  static List<PokemonType> fromStringList(List<String> types) {
    return types.map((t) => fromString(t)).toList();
  }

  /// Converts PokemonType list back to string list (for API compatibility).
  static List<String> toStringList(List<PokemonType> types) {
    return types.map((t) => t.name).toList();
  }
}

/// Extension for easier color access on type lists.
extension PokemonTypeListExtension on List<PokemonType> {
  /// Returns the primary type's color (first type in list).
  Color get primaryColor => isEmpty ? PokemonType.unknown.color : first.color;

  /// Returns display names as a list.
  List<String> get displayNames => map((t) => t.displayName).toList();
}
