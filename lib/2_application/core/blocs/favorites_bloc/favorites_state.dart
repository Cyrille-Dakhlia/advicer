part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  final List<AdviceEntity> favorites;

  const FavoritesState({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial({required super.favorites});
}

final class FavoritesAddInProgress extends FavoritesState {
  const FavoritesAddInProgress({required super.favorites});
}

final class FavoritesAddSuccess extends FavoritesState {
  const FavoritesAddSuccess({required super.favorites});
}

final class FavoritesAddFailure extends FavoritesState {
  final String message;
  const FavoritesAddFailure({required super.favorites, required this.message});

  @override
  List<Object> get props => [...super.props, message];
}

final class FavoritesRemoveInProgress extends FavoritesState {
  const FavoritesRemoveInProgress({required super.favorites});
}

final class FavoritesRemoveSuccess extends FavoritesState {
  const FavoritesRemoveSuccess({required super.favorites});
}

final class FavoritesRemoveFailure extends FavoritesState {
  final String message;
  const FavoritesRemoveFailure(
      {required super.favorites, required this.message});

  @override
  List<Object> get props => [...super.props, message];
}
