import 'package:adviser/2_application/pages/adviser/widgets/advice_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({required String advice}) {
    return MaterialApp(
      home: AdviceField(advice: advice),
    );
  }

  group('AdviceField', () {
    group('should be displayed correctly', () {
      testWidgets('when a text is given', (widgetTester) async {
        // GIVEN
        const inputText = 'Hmm';
        await widgetTester.pumpWidget(createWidgetUnderTest(advice: inputText));

        // WHEN - THEN
        final adviceFieldText = find.text('"$inputText"');
        expect(adviceFieldText, findsOneWidget);
      });

      testWidgets('when no text is given', (widgetTester) async {
        // GIVEN
        const inputEmpty = '';
        await widgetTester
            .pumpWidget(createWidgetUnderTest(advice: inputEmpty));
        await widgetTester.pumpAndSettle();

        // WHEN - THEN
        final backupAdviceFinder = find.text(AdviceField.backupAdvice);
        expect(backupAdviceFinder, findsOneWidget);

        final adviceText =
            widgetTester.widget<AdviceField>(find.byType(AdviceField)).advice;

        expect(adviceText, inputEmpty);
      });
    });
  });
}
