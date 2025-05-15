import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_page.dart';
import 'package:provider/provider.dart';

import 'core/di/injector.dart';
import 'features/home/presentation/home_page.dart';
import 'features/home/presentation/home_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await Hive.initFlutter();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<HomeViewModel>()..fetchInitialPokemons(),
      child: const MaterialApp(
        home: PokemonDetailPage(
          pokemonName: 'pikachu',
        ),
      ),
    );
  }
}
