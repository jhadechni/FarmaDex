import 'package:flutter/material.dart';

import '../domain/favorites_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository repository;

  FavoritesViewModel(this.repository);

  List<String> get favorites => repository.getFavorites();

  bool isFavorite(String name) => repository.isFavorite(name);

  Future<void> toggle(String name) async {
    await repository.toggle(name);
    notifyListeners();
  }

}
