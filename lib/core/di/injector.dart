import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/home/data/pokemon_repository_impl.dart';
import '../../features/home/domain/pokemon_repository.dart';
import '../../features/home/presentation/home_view_model.dart';
import '../../features/pokemon_detail/data/pokemon_detail_repository_impl.dart';
import '../../features/pokemon_detail/domain/pokemon_detail_repository.dart';
import '../../features/pokemon_detail/presentation/pokemon_detail_view_model.dart';

final sl = GetIt.instance;

void init() {
   sl.registerLazySingleton(() => http.Client());

  // Home
  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(sl()));
  sl.registerFactory(() => HomeViewModel(sl()));

  // Detail
  sl.registerLazySingleton<PokemonDetailRepository>(() => PokemonDetailRepositoryImpl(sl()));
  sl.registerFactory(() => PokemonDetailViewModel(sl()));

}
