import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class MockAdviceUseCases extends mocktail.Mock implements AdviceUseCases {}

void main() {
  group('AdviserBloc', () {
    final mockAdviceUseCases = MockAdviceUseCases();
    const inputAdvice = 'test';
    const inputAdviceId = 3;

    // Since we're using the same mock instance accross the tests, we make sure there's no interference
    setUp(() => mocktail.reset(mockAdviceUseCases));

    group('should not emit anything', () {
      blocTest<AdviserBloc, AdviserState>(
        'when no event is added.',
        build: () => AdviserBloc(adviceUseCases: mockAdviceUseCases),
        expect: () => const <AdviserState>[],
      );
    });

    group('should emit', () {
      blocTest<AdviserBloc, AdviserState>(
        '[AdviserLoadInProgress, AdviserLoadSuccess] with the correct advice when AdviserRequestPressed is added and AdviceUseCases returns left with an AdviceEntity',
        setUp: () {
          const inputLeftAdviceEntity = Left<AdviceEntity, Failure>(
              AdviceEntity(advice: inputAdvice, id: inputAdviceId));
          mocktail
              .when(() => mockAdviceUseCases.getAdvice())
              .thenAnswer((_) => Future.value(inputLeftAdviceEntity));
        },
        build: () => AdviserBloc(adviceUseCases: mockAdviceUseCases),
        act: (bloc) => bloc.add(AdviserRequestPressed()),
        // wait: const Duration(seconds: 3), //* if operations in bloc take time, we might need to wait a little before executing the expect function
        expect: () => const <AdviserState>[
          AdviserLoadInProgress(),
          AdviserLoadSuccess(advice: inputAdvice, adviceId: inputAdviceId)
        ],
      );

      group(
          '[AdviserLoadInProgress, AdviserLoadFailure] with the correct failure message when AdviserRequestPressed is added',
          () {
        blocTest<AdviserBloc, AdviserState>(
          'and AdviceUseCases returns right with a ServerFailure',
          setUp: () {
            final inputRightFailure =
                Right<AdviceEntity, Failure>(ServerFailure());
            mocktail.when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
                  (_) => Future.value(inputRightFailure),
                );
          },
          build: () => AdviserBloc(adviceUseCases: mockAdviceUseCases),
          act: (bloc) => bloc.add(AdviserRequestPressed()),
          // wait: const Duration(seconds: 3), //* if operations in bloc take time, we might need to wait a little before executing the expect function
          expect: () => const <AdviserState>[
            AdviserLoadInProgress(),
            AdviserLoadFailure(message: serverFailureMessage)
          ],
        );

        blocTest<AdviserBloc, AdviserState>(
          'and AdviceUseCases returns right with a CacheFailure',
          setUp: () {
            final inputRightFailure =
                Right<AdviceEntity, Failure>(CacheFailure());
            mocktail.when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
                  (_) => Future.value(inputRightFailure),
                );
          },
          build: () => AdviserBloc(adviceUseCases: mockAdviceUseCases),
          act: (bloc) => bloc.add(AdviserRequestPressed()),
          // wait: const Duration(seconds: 3), //* if operations in bloc take time, we might need to wait a little before executing the expect function
          expect: () => const <AdviserState>[
            AdviserLoadInProgress(),
            AdviserLoadFailure(message: cacheFailureMessage)
          ],
        );

        blocTest<AdviserBloc, AdviserState>(
          'and AdviceUseCases returns right with a GeneralFailure',
          setUp: () {
            final inputRightFailure =
                Right<AdviceEntity, Failure>(GeneralFailure());
            mocktail.when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
                  (_) => Future.value(inputRightFailure),
                );
          },
          build: () => AdviserBloc(adviceUseCases: mockAdviceUseCases),
          act: (bloc) => bloc.add(AdviserRequestPressed()),
          // wait: const Duration(seconds: 3), //* if operations in bloc take time, we might need to wait a little before executing the expect function
          expect: () => const <AdviserState>[
            AdviserLoadInProgress(),
            AdviserLoadFailure(message: generalFailureMessage)
          ],
        );
      });
    });
  });
}
