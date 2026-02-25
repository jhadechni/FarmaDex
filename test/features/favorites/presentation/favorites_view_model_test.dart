import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/favorites/presentation/favorites_view_model.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';

import '../../../shared/fixtures/pokemon_fixtures.dart';
import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  group('FavoritesViewModel', () {
    test('exposes favorite names and entities from repository', () {
      final favorite = makePokemonDetailEntity(name: 'Charmander');
      final repository = FakeFavoritesRepository(
        favorites: <PokemonDetailEntity>[favorite],
      );
      final viewModel = FavoritesViewModel(repository);

      expect(viewModel.favoriteNames, <String>['Charmander']);
      expect(viewModel.favoritePokemons.length, 1);
      expect(viewModel.isFavorite('Charmander'), isTrue);
    });

    test('toggle delegates to repository and notifies listeners', () async {
      final favorite = makePokemonDetailEntity(name: 'Squirtle');
      final repository = FakeFavoritesRepository(
        favorites: <PokemonDetailEntity>[favorite],
      );
      final viewModel = FavoritesViewModel(repository);
      var notifications = 0;
      viewModel.addListener(() => notifications += 1);

      await viewModel.toggle('Squirtle');

      expect(repository.toggleCallCount, 1);
      expect(repository.lastToggledName, 'Squirtle');
      expect(viewModel.isFavorite('Squirtle'), isFalse);
      expect(notifications, 1);
    });
  });
}
