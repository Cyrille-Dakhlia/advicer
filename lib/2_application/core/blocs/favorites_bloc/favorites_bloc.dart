import 'dart:async';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesInitial(favorites: [])) {
    on<FavoritesAdviceAdded>(_onAdviceAdded);
    on<FavoritesAdviceRemoved>(_onAdviceRemoved);
  }

  Future<FutureOr<void>> _onAdviceAdded(
      FavoritesAdviceAdded event, emit) async {
    emit(FavoritesAddInProgress(favorites: state.favorites));

    debugPrint('Faking server request: Advice addition to favorites.');
    await Future.delayed(const Duration(seconds: 3));
    final updatedList = [
      ...state.favorites,
      AdviceEntity(advice: event.advice, id: event.adviceId),
    ];

    debugPrint('Faking server response: Advice added to favorites.');

    emit(FavoritesAddSuccess(favorites: updatedList));

    // emit(FavoritesAddFailure(
    //     favorites: state.favorites,
    //     message: 'error message, favorite not added'));
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
