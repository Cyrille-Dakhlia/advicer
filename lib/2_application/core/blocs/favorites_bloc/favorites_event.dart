part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

final class FavoritesInitialDataLoadStarted extends FavoritesEvent {}

final class FavoritesAdviceAdded extends FavoritesEvent {
  final String advice;
  final int adviceId;
  FavoritesAdviceAdded({required this.advice, required this.adviceId});
}

final class FavoritesAdviceRemoved extends FavoritesEvent {
  final String advice;
  final int adviceId;
  FavoritesAdviceRemoved({required this.advice, required this.adviceId});
}
