import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/utils/result.dart';
import 'package:pokedex/features/pokemon_detail/domain/pokemon_detail_entity.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';

import '../../../shared/fixtures/pokemon_fixtures.dart';
import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  group('PokemonDetailViewModel', () {
    test('fetchDetail stores pokemon data on success', () async {
      final pokemon = makePokemonDetailEntity(name: 'Bulbasaur');
      final repository = FakePokemonDetailRepository(
        detailResult: Success(pokemon),
      );
      final viewModel = PokemonDetailViewModel(repository);

      await viewModel.fetchDetail('bulbasaur');

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.pokemonDetail, isA<PokemonDetailEntity>());
      expect(viewModel.pokemonDetail?.name, 'Bulbasaur');
      expect(repository.getPokemonDetailCallCount, 1);
    });

    test('fetchDetail stores error message on failure', () async {
      final repository = FakePokemonDetailRepository(
        detailResult: const Failure<PokemonDetailEntity>(
          NetworkException('Timeout'),
        ),
      );
      final viewModel = PokemonDetailViewModel(repository);

      await viewModel.fetchDetail('bulbasaur');

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.pokemonDetail, isNull);
      expect(viewModel.errorMessage, 'Timeout');
    });
  });
}
