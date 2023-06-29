part of 'adviser_bloc.dart';

@immutable
sealed class AdviserState extends Equatable {
  const AdviserState();
  @override
  List<Object?> get props => [];
}

final class AdviserInitial extends AdviserState {
  const AdviserInitial();
}

final class AdviserLoadInProgress extends AdviserState {
  const AdviserLoadInProgress();
}

final class AdviserLoadSuccess extends AdviserState {
  final String advice;
  const AdviserLoadSuccess({required this.advice});

  @override
  List<Object?> get props => [advice];
}

final class AdviserLoadFailure extends AdviserState {
  final String message;
  const AdviserLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
