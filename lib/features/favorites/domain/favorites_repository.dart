abstract class FavoritesRepository {
  List<String> getFavorites();
  bool isFavorite(String name);
  Future<void> toggle(String name);
}
