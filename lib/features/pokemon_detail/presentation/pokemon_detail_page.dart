import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'about_tab.dart';
import 'base_stats_tab.dart';
import 'evolution_tab.dart';
import 'moves_tab.dart';
import '../../../core/utils/color_mapper.dart';
import '../../../core/widgets/pokeball_logo.dart';
import '../../../core/widgets/type_chips.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PokemonDetailViewModel>();
    final pokemon = viewModel.pokemonDetail;

    if (viewModel.isLoading || pokemon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final color = pokemon.color.toColor();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color,
      body: Stack(
        children: [
          // HEADER
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
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

          // Fondo blanco detrás del panel
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

          // Pokebola
          Positioned(
            top: size.height * 0.24,
            left: size.width * 0.76 - 40,
            child: PokeballLogo(
              size: 150,
              color: Colors.white.withOpacity(0.2),
            ),
          ),

          // Imagen
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

          // Panel
          SlidingUpPanel(
            controller: _panelController,
            maxHeight: size.height * 0.9,
            minHeight: size.height * 0.59,
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
                      children: [
                        AboutTab(pokemon: pokemon,),
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
