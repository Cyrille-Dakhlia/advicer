import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'adviser_event.dart';
part 'adviser_state.dart';

class AdviserBloc extends Bloc<AdviserEvent, AdviserState> {
  AdviserBloc() : super(AdviserInitial()) {
    on<AdviserRequestPressed>(_onRequestPressed);
  }

  FutureOr<void> _onRequestPressed(event, emit) async {
    emit(AdviserLoadInProgress());
    // we temporarily simulate business logic here
    debugPrint('Retrieving advice...');
    await Future.delayed(const Duration(seconds: 3));
    debugPrint('Advice retrieved.');

    emit(AdviserLoadSuccess(
        advice: 'Fake advice fasely retrieved from fake API.'));

    // emit(AdviserLoadFailure(message: 'Fake error message.'));
  }
}
