import 'dart:io';

import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/0_data/models/advice_model.dart';
import 'package:adviser/0_data/repositories/advice_repo_impl.dart';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'advice_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRemoteDataSource>()])
void main() {
  group('AdviceRepoImpl', () {
    final mockAdviceRemoteDataSource = MockAdviceRemoteDataSource();
    final adviceRepoUnderTest =
        AdviceRepoImpl(adviceRemoteDataSource: mockAdviceRemoteDataSource);

    // Since we're using the same mock instance accross the tests, we make sure there's no interference
    setUp(() => reset(mockAdviceRemoteDataSource));

    group('should return left with an AdviceEntity', () {
      test('when AdviceRemoteDatasource returns an AdviceModel', () async {
        // GIVEN
        const inputAdviceModel = AdviceModel(advice: 'test', id: 1);

        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenAnswer((_) => Future.value(inputAdviceModel));

        // WHEN
        final result = await adviceRepoUnderTest.getAdviceFromDataSource();

        // THEN
        final expected = AdviceModel(
          advice: inputAdviceModel.advice,
          id: inputAdviceModel.id,
        );
        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<AdviceEntity, Failure>(expected));
      });
    });

    group('should return right with', () {
      test('a ServerFailure when a ServerException occurs', () async {
        // GIVEN
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(ServerException());

        // WHEN
        final result = await adviceRepoUnderTest.getAdviceFromDataSource();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(ServerFailure()));
      });

      test('a CacheFailure when a CacheException occurs', () async {
        // GIVEN
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(CacheException());

        // WHEN
        final result = await adviceRepoUnderTest.getAdviceFromDataSource();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(CacheFailure()));
      });

      test(
          'a GeneralFailure when another exception than ServerException or CacheException occurs',
          () async {
        // GIVEN
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(const SocketException('test'));

        // WHEN
        final result = await adviceRepoUnderTest.getAdviceFromDataSource();

        // THEN
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<AdviceEntity, Failure>(GeneralFailure()));
      });
    });

    group('should make a single call to AdviceRemoteDataSource', () {
      test('when calling getRandomAdviceFromApi', () async {
        // WHEN
        await adviceRepoUnderTest.getAdviceFromDataSource();

        // THEN
        verify(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).called(1);
        verifyNoMoreInteractions(mockAdviceRemoteDataSource);
      });
    });
  });
}
