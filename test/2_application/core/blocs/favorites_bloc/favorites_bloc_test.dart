import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class MockAdviceUseCases extends mocktail.Mock implements AdviceUseCases {}

void main() {
  group('FavoritesBloc', () {
    final mockAdviceUseCases = MockAdviceUseCases();
    const inputListOfFavorites = [
      AdviceEntity(advice: 'First advice', id: 1),
      AdviceEntity(advice: 'Second advice', id: 2),
    ];
    const inputAdvice = 'An advice';
    const inputAdviceId = 0;
    const inputAdviceEntity =
        AdviceEntity(advice: inputAdvice, id: inputAdviceId);

    // Since we're using the same mock instance accross the tests, we make sure there's no interference
    setUp(() => mocktail.reset(mockAdviceUseCases));

    group('should not emit anything', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'when no event is added.',
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        expect: () => const <FavoritesState>[],
      );
    });

    group('should emit', () {
      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesInitialLoadInProgress, FavoritesInitialLoadSuccess] when FavoritesInitialLoadDataStarted is added and AdviceUseCases returns a list of AdviceEntity.',
        setUp: () => mocktail
            .when(() => mockAdviceUseCases.getFavoritesFromDataSource())
            .thenAnswer((_) => Future.value(inputListOfFavorites)),
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        act: (bloc) => bloc.add(FavoritesInitialDataLoadStarted()),
        expect: () => const <FavoritesState>[
          FavoritesInitialLoadInProgress(favorites: []),
          FavoritesInitialLoadSuccess(favorites: inputListOfFavorites)
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesAddInProgress, FavoritesAddSuccess] when FavoritesAdviceAdded is added, and advice not already in favorites, and advice added to favorites, and AdviceUseCases returns true for updating favorites in datasource.',
        setUp: () {
          mocktail
              .when(() => mockAdviceUseCases
                  .checkIfAdviceAlreadyInFavorites(inputAdviceId, []))
              .thenReturn(false);
          mocktail
              .when(() => mockAdviceUseCases
                  .addAdviceToFavorites(inputAdviceEntity, []))
              .thenReturn([inputAdviceEntity]);
          mocktail
              .when(() => mockAdviceUseCases
                  .updateFavoritesInDataSource([inputAdviceEntity]))
              .thenAnswer((_) => Future.value(true));
        },
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        act: (bloc) => bloc.add(
            FavoritesAdviceAdded(advice: inputAdvice, adviceId: inputAdviceId)),
        expect: () => const <FavoritesState>[
          FavoritesAddInProgress(favorites: []),
          FavoritesAddSuccess(favorites: [inputAdviceEntity])
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesAddInProgress, FavoritesAddFailure] when FavoritesAdviceAdded is added, and advice not already in favorites, and advice added to favorites, and AdviceUseCases returns false for updating favorites in datasource.',
        setUp: () {
          mocktail
              .when(() => mockAdviceUseCases
                  .checkIfAdviceAlreadyInFavorites(inputAdviceId, []))
              .thenReturn(false);
          mocktail
              .when(() => mockAdviceUseCases
                  .addAdviceToFavorites(inputAdviceEntity, []))
              .thenReturn([inputAdviceEntity]);
          mocktail
              .when(() => mockAdviceUseCases
                  .updateFavoritesInDataSource([inputAdviceEntity]))
              .thenAnswer((_) => Future.value(false));
        },
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        act: (bloc) => bloc.add(
            FavoritesAdviceAdded(advice: inputAdvice, adviceId: inputAdviceId)),
        expect: () => const <FavoritesState>[
          FavoritesAddInProgress(favorites: []),
          FavoritesAddFailure(favorites: [], message: additionFailureMessage),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesAddInProgress, FavoritesAddFailure] when FavoritesAdviceAdded is added and advice already in favorites.',
        setUp: () => mocktail
            .when(() => mockAdviceUseCases
                .checkIfAdviceAlreadyInFavorites(inputAdviceId, []))
            .thenReturn(true),
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        act: (bloc) => bloc.add(
            FavoritesAdviceAdded(advice: inputAdvice, adviceId: inputAdviceId)),
        expect: () => const <FavoritesState>[
          FavoritesAddInProgress(favorites: []),
          FavoritesAddFailure(
              favorites: [], message: adviceAlreadyInFavoritesFailureMessage),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesRemoveInProgress, FavoritesRemoveSuccess] when FavoritesAdviceRemoved is added, and advice removed from favorites, and AdviceUseCases returns true for updating favorites in datasource.',
        setUp: () {
          mocktail
              .when(() => mockAdviceUseCases
                  .removeFromFavorites(inputAdviceId, [inputAdviceEntity]))
              .thenReturn([]);
          mocktail
              .when(() => mockAdviceUseCases.updateFavoritesInDataSource([]))
              .thenAnswer((_) => Future.value(true));
        },
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        seed: () => const FavoritesAddSuccess(favorites: [inputAdviceEntity]),
        act: (bloc) => bloc.add(FavoritesAdviceRemoved(
            advice: inputAdvice, adviceId: inputAdviceId)),
        expect: () => const <FavoritesState>[
          FavoritesRemoveInProgress(
            favorites: [inputAdviceEntity],
          ),
          FavoritesRemoveSuccess(favorites: []),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        '[FavoritesRemoveInProgress, FavoritesRemoveFailure] when FavoritesAdviceRemoved is added, and advice removed from favorites, and AdviceUseCases returns false for updating favorites in datasource.',
        setUp: () {
          mocktail
              .when(() => mockAdviceUseCases
                  .removeFromFavorites(inputAdviceId, [inputAdviceEntity]))
              .thenReturn([]);

          mocktail
              .when(() => mockAdviceUseCases.updateFavoritesInDataSource([]))
              .thenAnswer((_) => Future.value(false));
        },
        build: () => FavoritesBloc(adviceUseCases: mockAdviceUseCases),
        seed: () => const FavoritesAddSuccess(favorites: [inputAdviceEntity]),
        act: (bloc) => bloc.add(FavoritesAdviceRemoved(
            advice: inputAdvice, adviceId: inputAdviceId)),
        expect: () => const <FavoritesState>[
          FavoritesRemoveInProgress(favorites: [inputAdviceEntity]),
          FavoritesRemoveFailure(
              favorites: [inputAdviceEntity], message: removalFailureMessage)
        ],
      );
    });
  });
}
