import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_page.dart';
import 'package:pokedex/features/pokemon_detail/presentation/pokemon_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  testWidgets('shows error state when view model has error', (tester) async {
    final viewModel = PokemonDetailViewModel(FakePokemonDetailRepository())
      ..errorMessage = 'Failed to get details';

    await tester.pumpWidget(
      ChangeNotifierProvider<PokemonDetailViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: PokemonDetailPage()),
      ),
    );

    expect(find.text('Failed to load Pokémon'), findsOneWidget);
    expect(find.text('Failed to get details'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Go Back'), findsOneWidget);
  });

  testWidgets('shows loading state while detail is loading', (tester) async {
    final viewModel = PokemonDetailViewModel(FakePokemonDetailRepository())
      ..isLoading = true;

    await tester.pumpWidget(
      ChangeNotifierProvider<PokemonDetailViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: PokemonDetailPage()),
      ),
    );

    expect(find.text('Loading Pokémon details...'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
