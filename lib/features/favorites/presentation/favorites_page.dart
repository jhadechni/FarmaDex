import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/core/routing/app_router.dart';
import 'favorite_pokemon_card.dart';
import 'favorites_view_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesViewModel>(
      builder: (context, viewModel, _) {
        final favorites = viewModel.favoritePokemons;

        return Scaffold(
          appBar: AppBar(title: const Text('Favorite Pokémons')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Slide to the left to delete a favorite',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: favorites.isEmpty
                      ? const Center(child: Text("No favorites yet"))
                      : ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (_, index) {
                            final pokemon = favorites[index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 300 + (index * 80)),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(30 * (1 - value), 0),
                                    child: child,
                                  ),
                                );
                              },
                              child: Dismissible(
                                key: ValueKey(pokemon.name),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) =>
                                    viewModel.toggle(pokemon.name),
                                background: Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                ),
                                child: FavoritePokemonCard(
                                  pokemon: pokemon,
                                  onTap: () {
                                    context.push(AppRoutes.pokemonDetailPath(pokemon.name));
                                  },
                                  onDelete: () => viewModel.toggle(pokemon.name),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
