import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
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

class MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

void main() {
  Widget createWidgetUnderTest({
    required AdviserBloc adviserBloc,
    FavoritesBloc? favoritesBloc,
  }) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => ThemeService(),
        child: (favoritesBloc == null)
            ? BlocProvider.value(
                value: adviserBloc,
                child: const AdviserPage(),
              )
            : MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: adviserBloc,
                  ),
                  BlocProvider.value(
                    value: favoritesBloc,
                  ),
                ],
                child: const AdviserPage(),
              ),
      ),
    );
  }

  group('AdviserPage', () {
    late MockAdviserBloc mockAdviserBloc;
    late MockFavoritesBloc mockFavoritesBloc;

    setUp(() {
      mockAdviserBloc = MockAdviserBloc();
      mockFavoritesBloc = MockFavoritesBloc();
    });

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

      group('AdviserLoadSuccess when AdviserBloc emits AdviserLoadSuccess', () {
        testWidgets(
            'and with advice as favorite when FavoritesBloc\'s state contains it',
            (widgetTester) async {
          // GIVEN
          const inputAdvice = 'Good';
          const inputAdviceId = 3;

          whenListen(
            mockAdviserBloc,
            Stream.fromIterable([
              const AdviserLoadSuccess(
                  advice: inputAdvice, adviceId: inputAdviceId)
            ]),
            initialState: const AdviserInitial(),
          );

          whenListen(
            mockFavoritesBloc,
            Stream.fromIterable([
              //* We don't need a specific FavoritesState here, it can be any of them
              const FavoritesAddSuccess(favorites: [
                AdviceEntity(advice: inputAdvice, id: inputAdviceId)
              ])
            ]),
            initialState: const FavoritesInitial(favorites: []),
          );

          await widgetTester.pumpWidget(createWidgetUnderTest(
              adviserBloc: mockAdviserBloc, favoritesBloc: mockFavoritesBloc));

          // WHEN
          await widgetTester.pumpAndSettle();

          // THEN
          final clickableAdviceFieldFinder = find.byType(ClickableAdviceField);
          expect(clickableAdviceFieldFinder, findsOneWidget);

          final caf = widgetTester
              .widget<ClickableAdviceField>(clickableAdviceFieldFinder);
          expect(caf.advice, inputAdvice);
          expect(caf.isFavorite, isTrue);
        });
        testWidgets(
            'and without advice as favorite when FavoritesBloc\'s state does not contain it',
            (widgetTester) async {
          // GIVEN
          const inputAdvice = 'Good';
          const inputAdviceId = 3;
          const inputDifferentId = -1;

          whenListen(
            mockAdviserBloc,
            Stream.fromIterable([
              const AdviserLoadSuccess(
                  advice: inputAdvice, adviceId: inputAdviceId)
            ]),
            initialState: const AdviserInitial(),
          );

          whenListen(
            mockFavoritesBloc,
            Stream.fromIterable([
              //* We don't need a specific FavoritesState here, it can be any of them
              const FavoritesAddSuccess(favorites: [
                AdviceEntity(advice: inputAdvice, id: inputDifferentId)
              ])
            ]),
            initialState: const FavoritesInitial(favorites: []),
          );

          await widgetTester.pumpWidget(createWidgetUnderTest(
              adviserBloc: mockAdviserBloc, favoritesBloc: mockFavoritesBloc));

          // WHEN
          await widgetTester.pumpAndSettle();

          // THEN
          final clickableAdviceFieldFinder = find.byType(ClickableAdviceField);
          expect(clickableAdviceFieldFinder, findsOneWidget);

          final caf = widgetTester
              .widget<ClickableAdviceField>(clickableAdviceFieldFinder);
          expect(caf.advice, inputAdvice);
          expect(caf.isFavorite, isFalse);
        });
      });
    });
  });
}
