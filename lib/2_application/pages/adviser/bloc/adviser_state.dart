part of 'adviser_bloc.dart';

@immutable
sealed class AdviserState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AdviserInitial extends AdviserState {}

final class AdviserLoadInProgress extends AdviserState {}

final class AdviserLoadSuccess extends AdviserState {
  final String advice;
  AdviserLoadSuccess({required this.advice});

  @override
  List<Object?> get props => [advice];
}

final class AdviserLoadFailure extends AdviserState {
  final String message;
  AdviserLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
