import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:dotmeme/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// ignore_for_file: avoid_print
void main() {
  testWidgets('Basic home test', (WidgetTester tester) async {
    // Initialize DI (database etc) with test data
    di.init(di.Environment.test);
    final db = GetIt.I<Memebase>();

    await tester.pumpWidget(MyApp());
    expect(find.text("dotmeme"), findsOneWidget);
    expect(find.text("Loading..."), findsOneWidget);
    // Wait for sync to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text("You don't have any memes :/"), findsOneWidget);
    await db.setFolderEnabled(
      (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
      true,
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(Image), findsNWidgets(2));

    // You need to close the db yourself every time
    // Moor does some weird things when closing it's Streams - just do it!
    await db.close();
    await GetIt.I.reset(); // Oh and also reset getIt as always!
  });
}
