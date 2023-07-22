import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/adviser_page.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:adviser/2_application/pages/adviser/widgets/clickable_advice_field.dart';
import 'package:adviser/2_application/pages/adviser/widgets/error_message.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAdviserBloc extends MockBloc<AdviserEvent, AdviserState>
    implements AdviserBloc {}

void main() {
  Widget createWidgetUnderTest({required AdviserBloc adviserBloc}) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => ThemeService(),
        child: BlocProvider.value(
          value: adviserBloc,
          child: const AdviserPage(),
        ),
      ),
    );
  }

  group('AdviserPage', () {
    late MockAdviserBloc mockAdviserBloc;

    setUp(() => mockAdviserBloc = MockAdviserBloc());

    group('should be displayed in ViewState', () {
      testWidgets('AdviserInitial when AdviserBloc\'s state is AdviserInitial',
          (widgetTester) async {
        // GIVEN
        whenListen(
          mockAdviserBloc,
          Stream.fromIterable([
            const AdviserInitial()
          ]), // we can't have an empty Stream here due to the API implementation
          initialState: const AdviserInitial(),
        );

        await widgetTester
            .pumpWidget(createWidgetUnderTest(adviserBloc: mockAdviserBloc));

        // WHEN - THEN
        expect(find.text(AdviserPage.initialAdviceMessage), findsOneWidget);
      });

      testWidgets(
          'AdviserLoadInProgress when AdviserBloc emits AdviserLoadInProgress',
          (widgetTester) async {
        // GIVEN
        whenListen(
          mockAdviserBloc,
          Stream.fromIterable([const AdviserLoadInProgress()]),
          initialState: const AdviserInitial(),
        );

        await widgetTester
            .pumpWidget(createWidgetUnderTest(adviserBloc: mockAdviserBloc));

        // WHEN
        await widgetTester.pump();

        // THEN
        final circularProgressIndicatorFinder =
            find.byType(CircularProgressIndicator);
        expect(circularProgressIndicatorFinder, findsOneWidget);
      });

      testWidgets(
          'AdviserLoadSuccess when AdviserBloc emits AdviserLoadSuccess',
          (widgetTester) async {
        // GIVEN
        const inputAdvice = 'Good';
        whenListen(
          mockAdviserBloc,
          Stream.fromIterable([const AdviserLoadSuccess(advice: inputAdvice)]),
          initialState: const AdviserInitial(),
        );

        await widgetTester
            .pumpWidget(createWidgetUnderTest(adviserBloc: mockAdviserBloc));

        // WHEN
        await widgetTester.pump();

        // THEN
        final clickableAdviceFieldFinder = find.byType(ClickableAdviceField);
        expect(clickableAdviceFieldFinder, findsOneWidget);

        final adviceText = widgetTester
            .widget<ClickableAdviceField>(clickableAdviceFieldFinder)
            .advice;
        expect(adviceText, inputAdvice);
      });

      testWidgets(
          'AdviserLoadFailure when AdviserBloc emits AdviserLoadFailure',
          (widgetTester) async {
        // GIVEN
        const inputError = 'oops';
        whenListen(
          mockAdviserBloc,
          Stream.fromIterable([const AdviserLoadFailure(message: inputError)]),
          initialState: const AdviserInitial(),
        );

        await widgetTester
            .pumpWidget(createWidgetUnderTest(adviserBloc: mockAdviserBloc));

        // WHEN
        await widgetTester.pump();

        // THEN
        final errorMessageFinder = find.byType(ErrorMessage);
        expect(errorMessageFinder, findsOneWidget);

        final errorText =
            widgetTester.widget<ErrorMessage>(errorMessageFinder).message;
        expect(errorText, inputError);
      });
    });
  });
}
