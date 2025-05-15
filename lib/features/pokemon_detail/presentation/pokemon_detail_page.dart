import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import '../../favorites/presentation/favorites_view_model.dart';
import 'about_tab.dart';
import 'base_stats_tab.dart';
import 'evolution_tab.dart';
import 'moves_tab.dart';
import '../../../core/utils/color_mapper.dart';
import '../../../core/widgets/pokeball_logo.dart';
import '../../../core/widgets/type_chips.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PokemonDetailPage extends StatefulWidget {
  const PokemonDetailPage({super.key});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showTopNotification(BuildContext context, Widget content) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: content,
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 1500), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PokemonDetailViewModel>();
    final favViewModel = context.watch<FavoritesViewModel>();
    final pokemon = viewModel.pokemonDetail;

    if (viewModel.isLoading || pokemon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final color = pokemon.color.toColor();
    final size = MediaQuery.of(context).size;
    final normalizedName = pokemon.name[0].toUpperCase() + pokemon.name.substring(1).toLowerCase();
    final isFav = favViewModel.isFavorite(normalizedName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Detail',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white
            )),
        backgroundColor: color,
         iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favViewModel, _) {
              final isFav = favViewModel.isFavorite(normalizedName);
              return IconButton(
                icon: FaIcon(
                  isFav ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  favViewModel.toggle(normalizedName);

                  showTopNotification(
                    context,
                    Row(
                      children: [
                        FaIcon(
                          !isFav
                              ? FontAwesomeIcons.heartCirclePlus
                              : FontAwesomeIcons.heartCircleMinus,
                          color: !isFav ? Colors.green[400] : Colors.red[300],
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            !isFav
                                ? '${pokemon.name.capitalize()} added to favorites'
                                : '${pokemon.name.capitalize()} removed from favorites',
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: color,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pokemon.name.capitalize(),
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pokemon.number,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TypeChipList(types: pokemon.types, isVertical: false),
              ],
            ),
          ),

          Positioned(
            top: size.height * 0.38,
            left: 0,
            right: 0,
            child: Container(
              height: size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.24,
            left: size.width * 0.76 - 40,
            child: PokeballLogo(
              size: 150,
              color: Colors.white.withOpacity(0.2),
            ),
          ),

          Positioned(
            top: size.height * 0.15,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Image.network(
                pokemon.imageUrl,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SlidingUpPanel(
            controller: _panelController,
            maxHeight: size.height * 0.9,
            minHeight: size.height * 0.44,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const [],
            panelBuilder: (ScrollController scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Material(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 1,
                      indicatorPadding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF6C77E6),
                            width: 2,
                          ),
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Base Stats'),
                        Tab(text: 'Evolution'),
                        Tab(text: 'Moves'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        AboutTab(),
                        BaseStatsTab(),
                        EvolutionTab(),
                        MovesTab(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
