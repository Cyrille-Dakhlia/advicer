import 'dart:async';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required AdviceUseCases adviceUseCases})
      : _adviceUseCases = adviceUseCases,
        super(const FavoritesInitial(favorites: [])) {
    on<FavoritesInitialDataLoadStarted>(_onInitialDataLoadStarted);
    on<FavoritesAdviceAdded>(_onAdviceAdded,
        transformer:
            sequential()); //* To avoid user to add multiple times the same advice as favorite before the UI updates, we could use droppable() to drop successive event, but instead we use sequential() and treat duplicate events in the _onAdviceAdded method in the case where the user browses rapidly many advices and adds them all to favorites
    on<FavoritesAdviceRemoved>(_onAdviceRemoved,
        transformer:
            sequential()); //* We use sequential() because we want to keep every events
  }

  final AdviceUseCases _adviceUseCases;

  Future<FutureOr<void>> _onInitialDataLoadStarted(
      FavoritesInitialDataLoadStarted event, emit) async {
    emit(FavoritesInitialLoadInProgress(favorites: state.favorites));
    final loadedFavorites = await _adviceUseCases.getFavoritesFromDataSource();
    emit(FavoritesInitialLoadSuccess(favorites: loadedFavorites));
    //TODO: if catch Failure, emit FavoritesInitialLoadFailure
  }

  Future<FutureOr<void>> _onAdviceAdded(
      FavoritesAdviceAdded event, emit) async {
    emit(FavoritesAddInProgress(favorites: state.favorites));

    if (state.favorites.any((advice) => advice.id == event.adviceId)) {
      //HACK: We handle duplicate events here since we treat events sequentially (cf. transformer function applied on "on<Event>()"), in the case where the user would try to add multiple times the same advice to favorites before the UI updates
      emit(FavoritesAddFailure(
          favorites: state.favorites,
          message: 'Error message, advice already in favorites.'));
    } else {
      final updatedList = [
        ...state.favorites,
        AdviceEntity(advice: event.advice, id: event.adviceId),
      ];

      bool dataUpdated =
          await _adviceUseCases.updateFavoritesInDataSource(updatedList);
      //TODO: if _adviceUseCases.updateFavoritesInDataSource(...) returns Failure, emit FavoritesAddFailure

      if (dataUpdated) {
        emit(FavoritesAddSuccess(favorites: updatedList));
      } else {
        //TODO: later, handle offline feature with SharedPreferences to save data on device until Internet connection gets activated to save data on remote datasource
        emit(FavoritesAddFailure(
            favorites: state.favorites,
            message: 'Error message, advice not added, something went bad...'));
      }
    }
  }

  Future<FutureOr<void>> _onAdviceRemoved(
      FavoritesAdviceRemoved event, emit) async {
    emit(FavoritesRemoveInProgress(favorites: state.favorites));

    var updatedList = List<AdviceEntity>.from(state.favorites);
    // state.favorites.removeWhere((advice) => advice.id == event.adviceId);
    updatedList.removeWhere((advice) => advice.id == event.adviceId);

    bool dataUpdated =
        await _adviceUseCases.updateFavoritesInDataSource(updatedList);
    //TODO: if _adviceUseCases.updateFavoritesInDataSource(...) returns Failure, emit FavoritesRemoveFailure

    if (dataUpdated) {
      emit(FavoritesRemoveSuccess(favorites: updatedList));
    } else {
      //TODO: later, handle offline feature with SharedPreferences to save data on device until Internet connection gets activated to save data on remote datasource
      emit(FavoritesRemoveFailure(
          favorites: state.favorites,
          message: 'Error message, advice not removed, something went bad...'));
    }
  }
}
