// End-to-end test: launches the real app on a device or emulator and operates
// it like a user would — typing into the number field and tapping buttons.
//
// Run on the emulator:
//   flutter test integration_test -d emulator-5554
import 'package:calculator_demo/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final numberField = find.byKey(const Key('numberField'));
  final pending = find.byKey(const Key('pending'));
  final error = find.byKey(const Key('error'));
  Finder op(String name) => find.byKey(Key('op_$name'));
  final equals = find.byKey(const Key('equals'));

  String fieldText(WidgetTester tester) =>
      tester.widget<TextField>(numberField).controller!.text;
  String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

  Future<void> launch(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(numberField, findsOneWidget);
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.tap(numberField);
    await tester.enterText(numberField, text);
    await tester.pumpAndSettle();
  }

  Future<void> press(WidgetTester tester, Finder button) async {
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('12 + 3 = 15', (tester) async {
    await launch(tester);
    await type(tester, '12');
    await press(tester, op('add'));
    expect(textOf(tester, pending), '12 +');
    expect(fieldText(tester), isEmpty);
    await type(tester, '3');
    await press(tester, equals);
    expect(fieldText(tester), '15');
    expect(textOf(tester, pending), isEmpty);
  });

  testWidgets('all four operations, decimals and chaining', (tester) async {
    await launch(tester);
    for (final (a, o, b, result) in [
      ('7', 'subtract', '10', '-3'),
      ('2,5', 'multiply', '4', '10'),
      ('1', 'divide', '8', '0.125'),
    ]) {
      await type(tester, a);
      await press(tester, op(o));
      await type(tester, b);
      await press(tester, equals);
      expect(fieldText(tester), result, reason: '$a $o $b');
    }

    // Chaining: 2 + 3 × 4 is evaluated left to right → 20.
    await type(tester, '2');
    await press(tester, op('add'));
    await type(tester, '3');
    await press(tester, op('multiply'));
    expect(textOf(tester, pending), '5 ×');
    await type(tester, '4');
    await press(tester, equals);
    expect(fieldText(tester), '20');
  });

  testWidgets('division by zero shows an error', (tester) async {
    await launch(tester);
    await type(tester, '5');
    await press(tester, op('divide'));
    await type(tester, '0');
    await press(tester, equals);
    expect(textOf(tester, error), 'Cannot divide by zero');
  });
}
