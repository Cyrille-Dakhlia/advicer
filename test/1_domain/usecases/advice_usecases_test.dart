import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'advice_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRepo>()])
void main() {
  group('AdviceUseCases', () {
    final mockAdviceRepo = MockAdviceRepo();
    final adviceUseCasesUnderTest = AdviceUseCases(adviceRepo: mockAdviceRepo);

    // Since we're using the same mock instance accross the tests, we make sure there's no interference
    setUp(() => reset(mockAdviceRepo));

    group('should return left with an AdviceEntity', () {
      test('when AdviceRepo returns left with an AdviceEntity', () async {
        // GIVEN
        const inputLeftAdviceEntity =
            Left<AdviceEntity, Failure>(AdviceEntity(advice: 'test', id: 1));
        when(mockAdviceRepo.getAdviceFromDataSource()).thenAnswer((_) {
          return Future.value(inputLeftAdviceEntity);
        });

        // WHEN
        final result = await adviceUseCasesUnderTest.getAdvice();

        // THEN
        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
            result,
            Left<AdviceEntity, Failure>(AdviceEntity(
                advice: inputLeftAdviceEntity.value.advice,
                id: inputLeftAdviceEntity.value.id)));
      });
    });

    group('should return right with', () {
      test('a ServerFailure when AdviceRepo returns right with a ServerFailure',
          () async {
        // GIVEN
        final inputRightFailure = Right<AdviceEntity, Failure>(ServerFailure());
        when(mockAdviceRepo.getAdviceFromDataSource())
            .thenAnswer((_) => Future.value(inputRightFailure));

        // WHEN
        final result = await adviceUseCasesUnderTest.getAdvice();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(ServerFailure()));
      });

      test('a CacheFailure when AdviceRepo returns right with a CacheFailure',
          () async {
        // GIVEN
        final inputRightFailure = Right<AdviceEntity, Failure>(CacheFailure());
        when(mockAdviceRepo.getAdviceFromDataSource())
            .thenAnswer((_) => Future.value(inputRightFailure));

        // WHEN
        final result = await adviceUseCasesUnderTest.getAdvice();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(CacheFailure()));
      });

      test(
          'a GeneralFailure when AdviceRepo returns right with a GeneralFailure',
          () async {
        // GIVEN
        final inputRightFailure =
            Right<AdviceEntity, Failure>(GeneralFailure());
        when(mockAdviceRepo.getAdviceFromDataSource())
            .thenAnswer((_) => Future.value(inputRightFailure));

        // WHEN
        final result = await adviceUseCasesUnderTest.getAdvice();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(GeneralFailure()));
      });
    });

    group('should make a single call to AdviceRepo', () {
      test('when calling getAdviceFromDataSource()', () async {
        // WHEN
        await adviceUseCasesUnderTest.getAdvice();

        // THEN
        verify(mockAdviceRepo.getAdviceFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepo);
      });
    });
  });
}
