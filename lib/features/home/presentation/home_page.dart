import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pokemon_mini_card.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('FarmaDex')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.pokemons.length,
              itemBuilder: (_, index) {
                final pokemon = viewModel.pokemons[index];
                return ListTile(
                  title: Column(
                    children: [
                      MiniPokemonCard(
                        pokemonName: pokemon.name,
                        pokemonNumber: pokemon.number,
                        types: pokemon.types,
                        imagePath: pokemon.imageUrl,
                        color: pokemon.color
                      ),Text(
                        pokemon.color,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
