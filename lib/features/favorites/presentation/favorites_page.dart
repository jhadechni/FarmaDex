import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_page.dart';
import 'package:pokedex/core/di/injector.dart';
import 'favorite_pokemon_card.dart';
import 'favorites_view_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheBox = Hive.box<CachedPokemonDetail>('pokemon_detail_cache');

    return Consumer<FavoritesViewModel>(
      builder: (context, viewModel, _) {
        final favorites = viewModel.favorites
            .map((name) => cacheBox.get(name))
            .whereType<CachedPokemonDetail>()
            .toList();

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
                      ? const Center(child: Text("No favorites yet 😢"))
                      : ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (_, index) {
                            final cached = favorites[index];
                            final pokemon = cached.toModel();
                            return Dismissible(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) =>
                                            sl<PokemonDetailViewModel>()
                                              ..fetchDetail(pokemon.name),
                                        child: const PokemonDetailPage(),
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () => viewModel.toggle(pokemon.name),
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
