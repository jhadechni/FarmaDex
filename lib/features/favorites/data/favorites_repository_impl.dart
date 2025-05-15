import 'package:hive/hive.dart';
import 'package:pokedex/core/utils/string_utils.dart';

import '../domain/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  static const _boxName = 'favorites_box';

  late final Box<String> box;

  FavoritesRepositoryImpl() {
    box = Hive.box<String>(_boxName);
  }

  @override
  List<String> getFavorites() => box.values.toList();

  @override
  bool isFavorite(String name) => box.containsKey(name);

  @override
  Future<void> toggle(String name) async {
    final key = name.capitalize();
    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, key);
    }
  }

}
