import 'package:dappr/main.dart'; // Import your main app file to test it
import 'package:flutter/material.dart'; // Crucial for Widgets like MyApp, Icons
import 'package:flutter_test/flutter_test.dart'; // Crucial for expect, find, findsOneWidget, findsNothing

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // NOTE: If your main.dart does not have a counter app, this test will fail.
    // This is the default test provided by Flutter for new projects.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}