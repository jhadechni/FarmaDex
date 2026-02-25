import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/utils/result.dart';
import 'package:pokedex/features/home/domain/pokemon_entity.dart';
import 'package:pokedex/features/home/presentation/home_page.dart';
import 'package:pokedex/features/home/presentation/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  testWidgets('renders search input and floating action menu', (tester) async {
    final viewModel = HomeViewModel(FakePokemonRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Search Pokémon'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(SpeedDial), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('shows error state when initial load fails', (tester) async {
    final repository = FakePokemonRepository(
      pokemonsResult: const Failure<List<PokemonEntity>>(
        NetworkException('No internet'),
      ),
    );
    final viewModel = HomeViewModel(repository);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Failed to load Pokémon'), findsOneWidget);
    expect(find.text('No internet'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
