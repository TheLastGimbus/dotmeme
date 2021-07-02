import 'package:dotmeme/di.dart' as di;
import 'package:dotmeme/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic home test', (WidgetTester tester) async {
    // Initialize DI (database etc) with test data
    di.init(di.Environment.test);

    await tester.pumpWidget(MyApp());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Load some memes
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    // Some should be displayed
    expect(find.byType(Image), findsWidgets);
    expect(find.text("Loading"), findsNothing);
  });
}
