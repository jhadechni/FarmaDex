import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/color_mapper.dart';
import 'package:pokedex/core/widgets/pokeball_logo.dart';
import 'package:pokedex/core/widgets/type_chips.dart';
import 'package:pokedex/features/pokemon_detail/data/mock.dart';
import 'package:pokedex/features/pokemon_detail/presentation/about_tab.dart';
import 'package:pokedex/features/pokemon_detail/presentation/base_stats_tab.dart';
import 'package:pokedex/features/pokemon_detail/presentation/evolution_tab.dart';
import 'package:pokedex/features/pokemon_detail/presentation/moves_tab.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonName;

  const PokemonDetailPage({super.key, required this.pokemonName});

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
    final color = MockPokemonDetail.color.toColor();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color,
      body: Stack(
        children: [
          // Fondo con imagen y datos básicos
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y número
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      MockPokemonDetail.name,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      MockPokemonDetail.number,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const TypeChipList(
                    types: MockPokemonDetail.types, isVertical: false),
              ],
            ),
          ),

          // Contenedor blanco + imagen del Pokémon (ambos quedarán bajo el panel)
          Positioned(
            top: size.height *
                0.38, // Ajustado para que aparezca justo antes del panel
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
          // Logo de Pokéball
          Positioned(
            top: size.height * 0.24,
            left: size.width * 0.76 - 40,
            child: PokeballLogo(
              size: 150,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Imagen del Pokémon sobre el contenedor blanco
          Positioned(
            top: size.height * 0.15,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Image.network(
                MockPokemonDetail.imageUrl,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Panel deslizante (aparecerá por encima de todo lo anterior)
          SlidingUpPanel(
            controller: _panelController,
            maxHeight: size.height * 0.9,
            minHeight: size.height *
                0.59, // Ajustado para mostrar solo parte del panel inicialmente
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
