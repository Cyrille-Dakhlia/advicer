import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/adviser_page.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
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

  group('Golden Test - AdviserPage should be displayed correctly', () {
    testWidgets('when being in initial state AdviserInitial',
        (widgetTester) async {
      // GIVEN
      final mockAdviserBloc = MockAdviserBloc();
      whenListen(mockAdviserBloc, Stream.fromIterable([const AdviserInitial()]),
          initialState: const AdviserInitial());
      await widgetTester
          .pumpWidget(createWidgetUnderTest(adviserBloc: mockAdviserBloc));

      // WHEN - THEN
      await expectLater(find.byType(AdviserPage),
          matchesGoldenFile('goldens/adviser_page.png'));
    });
  });
}
