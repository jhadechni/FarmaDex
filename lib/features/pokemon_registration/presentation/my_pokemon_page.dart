import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/core/cache/adapters/registered_pokemon.dart';

class MyPokemonsPage extends StatelessWidget {
  const MyPokemonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<RegisteredPokemon>('registered_pokemons');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokémons'),
      ),
      body: ValueListenableBuilder<Box<RegisteredPokemon>>(
        valueListenable: box.listenable(),
        builder: (_, box, __) {
          final pokemons = box.values.toList();

          if (pokemons.isEmpty) {
            return const Center(
              child: Text(
                'No custom Pokémons registered yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pokemons.length,
            itemBuilder: (_, index) {
              if (index >= pokemons.length) return const SizedBox();

              final p = pokemons[index];

              return Dismissible(
                key: Key('${p.name}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => box.deleteAt(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF1FF),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${(index + 1).toString().padLeft(3, '0')}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildInfoChip(p.species),
                                const SizedBox(width: 6),
                                _buildGenderChip(p.gender),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildImage(p.imagePath),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImage(String path) {
    final file = File(path);
    final imageExists = file.existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: imageExists
          ? Image.file(
              file,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            )
          : Container(
              width: 72,
              height: 72,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGenderChip(String gender) {
    Color backgroundColor;
    if (gender.toLowerCase() == 'male') {
      backgroundColor = Colors.blue[100]!;
    } else if (gender.toLowerCase() == 'female') {
      backgroundColor = Colors.pink[100]!;
    } else {
      backgroundColor = Colors.grey[300]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        gender,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
