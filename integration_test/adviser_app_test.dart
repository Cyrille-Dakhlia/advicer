import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/adviser_page.dart';
import 'package:adviser/2_application/core/widgets/advice_field.dart';
import 'package:adviser/2_application/pages/adviser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:adviser/main.dart' as app;
import 'package:provider/provider.dart';
import 'package:adviser/injection.dart' as di;

void main() {
  Widget createApp() {
    return ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const app.MainApp(),
    );
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    setUpAll(() => di.setup());

    tearDownAll(() => di.getIt.reset());

    group('should verify that advice is loaded', () {
      testWidgets('when custom button is pressed', (widgetTester) async {
        // GIVEN
        await widgetTester.pumpWidget(createApp());
        await widgetTester.pumpAndSettle();
        expect(find.text(AdviserPage.initialAdviceMessage), findsOneWidget);

        final customButtonFinder = find.byType(CustomButton);
        expect(customButtonFinder, findsOneWidget);

        // WHEN
        await widgetTester.tap(customButtonFinder);
        await widgetTester.pump();

        // THEN
        final circularProgressIndicatorFinder =
            find.byType(CircularProgressIndicator);
        expect(circularProgressIndicatorFinder, findsOneWidget);

        await widgetTester.pumpAndSettle();
        expect(find.byType(AdviceField), findsOneWidget);
      });
    });

    group('should verify that theme changes', () {
      testWidgets('when switch button is pressed', (widgetTester) async {
        // GIVEN
        await widgetTester.pumpWidget(createApp());
        await widgetTester.pumpAndSettle();
        var materialAppFinder = find.byType(MaterialApp).first;
        final materialApp = widgetTester.widget<MaterialApp>(materialAppFinder);
        final initialThemeMode = materialApp.themeMode;

        // WHEN
        await widgetTester.tap(find.byType(Switch));
        await widgetTester.pumpAndSettle();

        // THEN
        final materialAppAfterChange =
            widgetTester.widget<MaterialApp>(materialAppFinder);
        final finalThemeMode = materialAppAfterChange.themeMode;

        expect(finalThemeMode == initialThemeMode, isFalse);

        final expected = initialThemeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
        expect(finalThemeMode, expected);
      });
    });
  });
}
