import 'dart:async';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'adviser_event.dart';
part 'adviser_state.dart';

class AdviserBloc extends Bloc<AdviserEvent, AdviserState> {
  AdviserBloc() : super(AdviserInitial()) {
    on<AdviserRequestPressed>(_onRequestPressed);
  }
  final AdviceUseCases adviceUseCases = AdviceUseCases();

  FutureOr<void> _onRequestPressed(event, emit) async {
    emit(AdviserLoadInProgress());

    final AdviceEntity adviceEntity = await adviceUseCases.getAdvice();
    emit(AdviserLoadSuccess(advice: adviceEntity.advice));

    // emit(AdviserLoadFailure(message: 'Fake error message.'));
  }
}
