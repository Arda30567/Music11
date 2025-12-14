import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MusicPlayerApp());

    // Verify that the app starts without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MusicPlayerApp), findsOneWidget);
  });

  testWidgets('Main screen has correct structure', (WidgetTester tester) async {
    await tester.pumpWidget(const MusicPlayerApp());

    // Verify the main structure
    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Bottom navigation bar exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MusicPlayerApp());

    // Verify bottom navigation elements
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Player'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}