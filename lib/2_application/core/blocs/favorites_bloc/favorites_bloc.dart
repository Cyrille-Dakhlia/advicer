import 'dart:async';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesInitial(favorites: [])) {
    on<FavoritesAdviceAdded>(_onAdviceAdded,
        transformer:
            sequential()); //* To avoid user to add multiple times the same advice as favorite before the UI updates, we could use droppable() to drop successive event, but instead we use sequential() and treat duplicate events in the _onAdviceAdded method in the case where the user browses rapidly many advices and adds them all to favorites
    on<FavoritesAdviceRemoved>(_onAdviceRemoved,
        transformer:
            sequential()); //* We use sequential() because we want to keep every events
  }

  Future<FutureOr<void>> _onAdviceAdded(
      FavoritesAdviceAdded event, emit) async {
    emit(FavoritesAddInProgress(favorites: state.favorites));

    debugPrint('Faking server request: Advice addition to favorites.');
    await Future.delayed(const Duration(seconds: 3));

    if (state.favorites.any((advice) => advice.id == event.adviceId)) {
      //HACK: We handle duplicate events here since we treat events sequentially (cf. transformer function applied on "on<Event>()"), in the case where the user would try to add multiple times the same advice to favorites before the UI updates
      debugPrint('Faking server response: Advice not added to favorites.');

      emit(FavoritesAddFailure(
          favorites: state.favorites,
          message: 'error message, favorite not added'));
    } else {
      final updatedList = [
        ...state.favorites,
        AdviceEntity(advice: event.advice, id: event.adviceId),
      ];

      debugPrint('Faking server response: Advice added to favorites.');

      emit(FavoritesAddSuccess(favorites: updatedList));
    }
  }

  Future<FutureOr<void>> _onAdviceRemoved(
      FavoritesAdviceRemoved event, emit) async {
    emit(FavoritesRemoveInProgress(favorites: state.favorites));

    debugPrint('Faking server request: Advice removal from favorites.');
    await Future.delayed(const Duration(seconds: 3));
    state.favorites.removeWhere((advice) => advice.id == event.adviceId);
    debugPrint('Faking server response: Advice removed from favorites.');

    emit(FavoritesRemoveSuccess(favorites: state.favorites));

    // emit(FavoritesRemoveFailure(
    //     favorites: state.favorites,
    //     message: 'error message, favorite not removed'));
  }
}
