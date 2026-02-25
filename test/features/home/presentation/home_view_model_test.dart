import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/utils/result.dart';
import 'package:pokedex/features/home/domain/pokemon_entity.dart';
import 'package:pokedex/features/home/presentation/home_view_model.dart';

import '../../../shared/fixtures/pokemon_fixtures.dart';
import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  group('HomeViewModel', () {
    test('fetchInitialPokemons updates list and loading state on success',
        () async {
      final pokemons = <PokemonEntity>[makePokemonEntity()];
      final repository = FakePokemonRepository(
        pokemonsResult: Success(pokemons),
      );
      final viewModel = HomeViewModel(repository);

      await viewModel.fetchInitialPokemons();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.pokemons.length, 1);
      expect(viewModel.offset, viewModel.limit);
      expect(repository.getPokemonsCallCount, 1);
    });

    test('fetchInitialPokemons sets error message on failure', () async {
      final repository = FakePokemonRepository(
        pokemonsResult: const Failure<List<PokemonEntity>>(
          NetworkException('Request failed'),
        ),
      );
      final viewModel = HomeViewModel(repository);

      await viewModel.fetchInitialPokemons();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, 'Request failed');
      expect(viewModel.pokemons, isEmpty);
    });

    test('updateSearchQuery fetches detail for matching name', () async {
      final detail = makePokemonEntity(name: 'pikachu', number: '#025');
      final repository = FakePokemonRepository(
        allNamesResult: const Success(<String>['pikachu']),
        detailResult: Success(detail),
      );
      final viewModel = HomeViewModel(repository);

      await viewModel.fetchAllPokemonNames();
      viewModel.updateSearchQuery('pika');
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(repository.getPokemonDetailCallCount, 1);
      expect(viewModel.searchResult?.name, 'pikachu');
      expect(viewModel.filteredPokemons.length, 1);
    });
  });
}
