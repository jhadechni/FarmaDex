// lib/core/local_storage/hive_init.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/core/cache/adapters/cached_pokemon_detail.dart';

import 'adapters/cached_evolution.dart';
import 'adapters/cached_move.dart';

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(CachedPokemonDetailAdapter());
  Hive.registerAdapter(CachedEvolutionAdapter());
  Hive.registerAdapter(CachedMoveAdapter());
}
