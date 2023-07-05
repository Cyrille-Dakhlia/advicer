import 'dart:async';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'adviser_event.dart';
part 'adviser_state.dart';

const serverFailureMessage = 'API Error, please try again.';
const cacheFailureMessage = 'Cache failed, please try again.';
const generalFailureMessage = 'Something\'s gone wrong, please try again.';

class AdviserBloc extends Bloc<AdviserEvent, AdviserState> {
  final AdviceUseCases _adviceUseCases;

  AdviserBloc({required AdviceUseCases adviceUseCases})
      : _adviceUseCases = adviceUseCases,
        super(const AdviserInitial()) {
    on<AdviserRequestPressed>(_onRequestPressed);
  }

  FutureOr<void> _onRequestPressed(event, emit) async {
    emit(const AdviserLoadInProgress());

    final adviceEntityOrFailure = await _adviceUseCases.getAdvice();
    adviceEntityOrFailure.fold(
      (adviceEntity) => emit(AdviserLoadSuccess(advice: adviceEntity.advice)),
      (failure) =>
          emit(AdviserLoadFailure(message: _mapFailureToMessage(failure))),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => serverFailureMessage,
      CacheFailure() => cacheFailureMessage,
      GeneralFailure() => generalFailureMessage,
    };
  }
}
