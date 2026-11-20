import 'package:calculator_demo/calculator.dart';
import 'package:calculator_demo/calculator_view.dart';
import 'package:calculator_demo/designs.dart';
import 'package:calculator_demo/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Calculator logic', () {
    test('basic operations', () {
      for (final (a, op, b, expected) in [
        ('12', Operation.add, '3', '15'),
        ('12', Operation.subtract, '3', '9'),
        ('12', Operation.multiply, '3', '36'),
        ('12', Operation.divide, '3', '4'),
        ('7', Operation.divide, '2', '3.5'),
      ]) {
        final c = Calculator();
        expect(c.pressOperation(a, op), isNull);
        expect(c.pressEquals(b), expected);
      }
    });

    test('decimal comma and float formatting', () {
      final c = Calculator()..pressOperation('0,1', Operation.add);
      expect(c.pressEquals('0.2'), '0.3');
    });

    test('chaining evaluates left to right', () {
      final c = Calculator()
        ..pressOperation('2', Operation.add)
        ..pressOperation('3', Operation.multiply);
      expect(c.pendingText, '5 ×');
      expect(c.pressEquals('4'), '20');
    });

    test('division by zero reports an error', () {
      final c = Calculator()..pressOperation('5', Operation.divide);
      expect(() => c.pressEquals('0'), throwsA(isA<CalculatorException>()));
    });

    test('invalid input reports an error', () {
      expect(Calculator().pressOperation('abc', Operation.add), isNotNull);
    });
  });

  setUpAll(() => useGoogleFonts = false);

  void phoneSize(WidgetTester tester, {Size size = const Size(1080, 2220)}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Future<void> calculate(WidgetTester tester) async {
    await tester.enterText(find.byKey(const Key('numberField')), '12');
    await tester.tap(find.byKey(const Key('op_add')));
    await tester.pump();
    expect(find.text('12 +'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('numberField')), '3');
    await tester.tap(find.byKey(const Key('equals')));
    await tester.pump();
    expect(find.text('15'), findsOneWidget);
  }

  testWidgets('UI computes 12 + 3 = 15', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(const CalculatorApp(gallery: false));
    await calculate(tester);
  });

  for (final design in designs) {
    testWidgets('design "${design.id}" lays out and works on a phone', (
      tester,
    ) async {
      phoneSize(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CalculatorView(design: design)),
        ),
      );
      // The design's background must cover the whole screen (360×740 dp).
      expect(tester.getSize(find.byType(CalculatorView)), const Size(360, 740));
      await calculate(tester);
      await tester.enterText(find.byKey(const Key('numberField')), 'x');
      await tester.tap(find.byKey(const Key('op_add')));
      await tester.pump();
      expect(find.text('Please enter a valid number'), findsOneWidget);
    });

    testWidgets('design "${design.id}" fits a small phone with keyboard open', (
      tester,
    ) async {
      // 360×640 dp phone with a 300 dp on-screen keyboard.
      phoneSize(tester, size: const Size(1080, 1920));
      tester.view.viewInsets = const FakeViewPadding(bottom: 900);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CalculatorView(design: design)),
        ),
      );
      await tester.enterText(find.byKey(const Key('numberField')), '5');
      await tester.tap(find.byKey(const Key('op_divide')), warnIfMissed: false);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('gallery shows every design', (tester) async {
    phoneSize(tester, size: const Size(4800, 7200));
    await tester.pumpWidget(const CalculatorApp(gallery: true));
    expect(find.byType(CalculatorView), findsNWidgets(designs.length));
    expect(find.text('Choose this design'), findsNWidgets(designs.length));
  });
}
