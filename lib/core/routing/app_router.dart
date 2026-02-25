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
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.pokemonDetail,
        name: 'pokemon-detail',
        builder: (context, state) {
          final pokemonName = state.pathParameters['name']!;
          return ChangeNotifierProvider(
            create: (_) => sl<PokemonDetailViewModel>()..fetchDetail(pokemonName),
            child: const PokemonDetailPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: AppRoutes.createPokemon,
        name: 'create-pokemon',
        builder: (context, state) => const PokemonRegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.myPokemons,
        name: 'my-pokemons',
        builder: (context, state) => const MyPokemonsPage(),
      ),
      GoRoute(
        path: AppRoutes.compass,
        name: 'compass',
        builder: (context, state) => const CompassPage(),
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
