import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokemon_registration/presentation/pokemon_registration_page.dart';

void main() {
  testWidgets('validates missing fields on submit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PokemonRegisterPage()),
    );

    expect(find.text('Create a Pokémon'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

    final saveButton = find.widgetWithText(ElevatedButton, 'Save Pokémon');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump();

    expect(
      find.text('Please complete all fields including image and gender.'),
      findsOneWidget,
    );
  });
}
