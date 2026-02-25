import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/widgets/pokemon_mini_card.dart';
import 'home_view_model.dart';

const Color primaryAccent = Color(0xFF6B79DB);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final viewModel = context.read<HomeViewModel>();
        viewModel.fetchInitialPokemons();
        viewModel.fetchAllPokemonNames();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: kToolbarHeight * 0.6,
          child: Image.asset(
            'lib/core/assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: viewModel.isLoading && viewModel.pokemons.isEmpty
          ? Padding(
            padding: const EdgeInsets.all(14),
            child: _buildSkeletonGrid(screenWidth),
          )
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextField(
                    controller: _searchController,
                    onChanged: viewModel.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search Pokémon',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
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
                      itemCount: viewModel.filteredPokemons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (_, index) {
                        final pokemon = viewModel.filteredPokemons[index];
                        return MiniPokemonCard(
                          onTap: () {
                            context.push(AppRoutes.pokemonDetailPath(pokemon.name));
                            logInfo('Navigating to detail page for ${pokemon.name}');
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
                  Center(
                      child: Lottie.asset(
                          'lib/core/assets/animations/ditto_charge.json')),
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
            context.push(AppRoutes.favorites);
          }, maxWidth),
          _buildLabelWidgetButton('Create a pokémon', FontAwesomeIcons.kiwiBird,
              () {
            context.push(AppRoutes.createPokemon);
          }, maxWidth),
          _buildLabelWidgetButton('My Pokémons', FontAwesomeIcons.medal, () {
            context.push(AppRoutes.myPokemons);
          }, maxWidth),
          _buildLabelWidgetButton('Compass', FontAwesomeIcons.compass, () {
            context.push(AppRoutes.compass);
          }, maxWidth),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid(double screenWidth) {
    int crossAxisCount = (screenWidth / 156).floor().clamp(1, 4);
    const double itemHeight = 156;
    final double itemWidth = screenWidth / crossAxisCount;
    final double aspectRatio = itemWidth / itemHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
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
