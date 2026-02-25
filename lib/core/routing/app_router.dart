import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/compass/presentation/compass_page.dart';
import '../../features/favorites/presentation/favorites_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/pokemon_detail/presentation/pokemon_detail_page.dart';
import '../../features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import '../../features/pokemon_registration/presentation/my_pokemon_page.dart';
import '../../features/pokemon_registration/presentation/pokemon_registration_page.dart';
import '../di/injector.dart';

/// Custom page transition that fades and slides up.
CustomTransitionPage<void> _buildFadeSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

/// Custom page transition that fades only.
CustomTransitionPage<void> _buildFadeTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

/// Application route paths.
abstract class AppRoutes {
  static const home = '/';
  static const pokemonDetail = '/pokemon/:name';
  static const favorites = '/favorites';
  static const createPokemon = '/create-pokemon';
  static const myPokemons = '/my-pokemons';
  static const compass = '/compass';

  /// Generates the pokemon detail path with the given name.
  static String pokemonDetailPath(String name) => '/pokemon/$name';
}

/// Creates and configures the application router.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildFadeTransition(
          context: context,
          state: state,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.pokemonDetail,
        name: 'pokemon-detail',
        pageBuilder: (context, state) {
          final pokemonName = state.pathParameters['name']!;
          return _buildFadeSlideTransition(
            context: context,
            state: state,
            child: ChangeNotifierProvider(
              create: (_) => sl<PokemonDetailViewModel>()..fetchDetail(pokemonName),
              child: const PokemonDetailPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        pageBuilder: (context, state) => _buildFadeTransition(
          context: context,
          state: state,
          child: const FavoritesPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.createPokemon,
        name: 'create-pokemon',
        pageBuilder: (context, state) => _buildFadeTransition(
          context: context,
          state: state,
          child: const PokemonRegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.myPokemons,
        name: 'my-pokemons',
        pageBuilder: (context, state) => _buildFadeTransition(
          context: context,
          state: state,
          child: const MyPokemonsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.compass,
        name: 'compass',
        pageBuilder: (context, state) => _buildFadeTransition(
          context: context,
          state: state,
          child: const CompassPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Route: ${state.uri.path}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
