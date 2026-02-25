import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/color_mapper.dart';
import 'package:pokedex/core/utils/string_utils.dart';
import 'package:pokedex/core/widgets/type_chips.dart';
import 'pokeball_logo.dart';

class MiniPokemonCard extends StatefulWidget {
  final String pokemonName;
  final String pokemonNumber;
  final List<String> types;
  final String imagePath;
  final String color;
  final VoidCallback onTap;
  final int animationIndex;

  const MiniPokemonCard({
    super.key,
    required this.pokemonName,
    required this.pokemonNumber,
    required this.types,
    required this.imagePath,
    required this.color,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<MiniPokemonCard> createState() => _MiniPokemonCardState();
}

class _MiniPokemonCardState extends State<MiniPokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (widget.animationIndex * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color.toColor(),
              ),
              child: Stack(
                children: [
                  // Pokébola decorativa
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: PokeballLogo(
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),

                  // Imagen del Pokémon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Hero(
                      tag: 'pokemon-image-${widget.pokemonName.capitalize()}',
                      child: Image.network(
                        widget.imagePath,
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png',
                            height: 90,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),

                  // Contenido textual
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            widget.pokemonNumber,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.pokemonName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: TypeChipList(types: widget.types, isVertical: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
