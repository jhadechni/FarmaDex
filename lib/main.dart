import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/core/cache/adapters/cached_move.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';
import 'package:provider/provider.dart';

import 'core/cache/adapters/cached_evolution.dart';
import 'core/cache/adapters/registered_pokemon.dart';
import 'core/di/injector.dart';
import 'features/favorites/presentation/favorites_view_model.dart';
import 'features/home/presentation/home_page.dart';
import 'features/home/presentation/home_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();

  await Hive.initFlutter();

  Hive.registerAdapter(CachedMoveAdapter());
  Hive.registerAdapter(CachedEvolutionAdapter());
  Hive.registerAdapter(CachedPokemonDetailAdapter());
  Hive.registerAdapter(RegisteredPokemonAdapter());
  try {
    await Hive.openBox<CachedPokemonDetail>('pokemon_detail_cache');
    await Hive.openBox<String>('favorites_box');
    await Hive.openBox<RegisteredPokemon>('registered_pokemons');
    logInfo('Hive boxes opened successfully');
  } catch (e, st) {
    logError('Error opening box: $e', e, st);
  }

  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => sl<HomeViewModel>()..fetchInitialPokemons()),
        ChangeNotifierProvider(create: (_) => sl<FavoritesViewModel>()),
      ],
      child: MaterialApp(
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.indigo,
            primarySwatch: Colors.indigo,
            fontFamily: 'ProductSans'),
      ),
    );
  }
}
