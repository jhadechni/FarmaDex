import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/home/data/pokemon_repository_impl.dart';
import '../../features/home/domain/pokemon_repository.dart';
import '../../features/home/presentation/home_view_model.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(sl()));
  sl.registerFactory(() => HomeViewModel(sl()));
}
