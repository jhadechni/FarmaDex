import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';
import 'package:pokedex/core/di/injector.dart';
import 'package:pokedex/features/favorites/presentation/favorites_page.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/pokemon_mini_card.dart';
import '../../pokemon_detail/presentation/pokemon_detail_page.dart';
import 'home_view_model.dart';

const Color primaryAccent = Color(0xFF6B79DB);

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
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmaDex'),
        leading: ElevatedButton(
          onPressed: () async {
            final favBox = Hive.box<String>('favorites_box');
            final cacheBox =
                Hive.box<CachedPokemonDetail>('pokemon_detail_cache');
            print('[DEBUG] Favoritos guardados: ${favBox.values.toList()}');
            print('[DEBUG] Cache contiene: ${cacheBox.keys}');
            await favBox.clear();
            await cacheBox.clear();
            print('[DEBUG2] Favoritos guardados: ${favBox.values.toList()}');
          },
          child: const Text('Borrar'),
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
                    int crossAxisCount =
                        (screenWidth / 156).floor().clamp(1, 4);
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
      floatingActionButton: SpeedDial(
        icon: FontAwesomeIcons.sliders,
        activeIcon: FontAwesomeIcons.x,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryAccent,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        elevation: 10,
        spacing: 16,
        animationDuration: const Duration(milliseconds: 200),
        spaceBetweenChildren: 5,
        children: [
          _buildLabelWidgetButton(
              'Favorite Pokemons', FontAwesomeIcons.solidHeart, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            );
          }, maxWidth),
        ],
      ),
    );
  }

  SpeedDialChild _buildLabelWidgetButton(
    String text,
    IconData icon,
    VoidCallback onTap,
    double maxWidth,
  ) {
    return SpeedDialChild(
      backgroundColor: Colors.white,
      elevation: 4,
      labelWidget: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            FaIcon(icon, color: primaryAccent, size: 18),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
