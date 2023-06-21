part of 'adviser_bloc.dart';

@immutable
sealed class AdviserState {}

final class AdviserInitial extends AdviserState {}

final class AdviserLoadInProgress extends AdviserState {}

final class AdviserLoadSuccess extends AdviserState {
  final String advice;

  AdviserLoadSuccess({required this.advice});
}

final class AdviserLoadFailure extends AdviserState {
  final String message;

  AdviserLoadFailure({required this.message});
}
