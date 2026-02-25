import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/favorites/presentation/favorites_page.dart';
import 'package:pokedex/features/favorites/presentation/favorites_view_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/test_doubles/fake_repositories.dart';

void main() {
  testWidgets('shows empty state when there are no favorites', (tester) async {
    final viewModel = FavoritesViewModel(FakeFavoritesRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );

    expect(find.text('Favorite Pokémons'), findsOneWidget);
    expect(find.text('Slide to the left to delete a favorite'), findsOneWidget);
    expect(find.text('No favorites yet'), findsOneWidget);
  });
}
