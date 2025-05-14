import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => http.Client());
  // servicios: repositorios, useCases, etc.
}
