import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';
import 'package:pokedex/core/di/injector.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pokemon_mini_card.dart';
import '../../pokemon_detail/presentation/pokemon_detail_page.dart';
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
      appBar: AppBar(
        title: const Text('FarmaDex'),
        leading: ElevatedButton(
          onPressed: () {
            final box = Hive.box<CachedPokemonDetail>('pokemon_detail_cache');
            final cached = box.get('Bulbasaur');
            logError(cached?.name ?? 'No data in cache');
          },
          child: const Text("Check Cache"),
        ),
      ),
      body: viewModel.isLoading && viewModel.pokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double screenWidth = constraints.maxWidth;

                    int crossAxisCount = (screenWidth / 156)
                        .floor()
                        .clamp(1, 4); // máx 4 columnas
                    final double itemWidth = screenWidth / crossAxisCount;
                    const double itemHeight = 156;
                    final double aspectRatio = itemWidth / itemHeight;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.pokemons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (_, index) {
                        final pokemon = viewModel.pokemons[index];
                        return MiniPokemonCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => sl<PokemonDetailViewModel>()
                                    ..fetchDetail(pokemon.name),
                                  child: const PokemonDetailPage(),
                                ),
                              ),
                            );
                            logInfo(
                              'Navigating to detail page for ${pokemon.name}',
                            );
                          },
                          pokemonName: pokemon.name,
                          pokemonNumber: pokemon.number,
                          types: pokemon.types,
                          imagePath: pokemon.imageUrl,
                          color: pokemon.color,
                        );
                      },
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
                        'No more pokemons, for now...',
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
