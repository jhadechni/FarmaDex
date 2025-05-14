import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pokemon_mini_card.dart';
import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeViewModel>().fetchInitialPokemons();
      }
    });

    _scrollController.addListener(() {
      final viewModel = context.read<HomeViewModel>();
      if (_shouldFetchMore(viewModel)) {
        viewModel.fetchMorePokemons();
      }
    });
  }

  bool _shouldFetchMore(HomeViewModel viewModel) {
    return _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !viewModel.isLoading &&
        !viewModel.isLoadingMore &&
        !viewModel.allLoaded;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('FarmaDex')),
      body: viewModel.isLoading && viewModel.pokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // GRID embebido dentro del ListView
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.pokemons.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (_, index) {
                    final pokemon = viewModel.pokemons[index];
                    return MiniPokemonCard(
                      pokemonName: pokemon.name,
                      pokemonNumber: pokemon.number,
                      types: pokemon.types,
                      imagePath: pokemon.imageUrl,
                      color: pokemon.color,
                    );
                  },
                ),

                const SizedBox(height: 16),

                if (viewModel.isLoadingMore)
                  const Center(child: CircularProgressIndicator()),

                if (viewModel.allLoaded && !viewModel.isLoadingMore)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 32),
                      child: Text(
                        'No hay más pokemons, por ahora...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
