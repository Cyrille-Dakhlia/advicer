part of 'favorites_bloc.dart';

sealed class FavoritesEvent {
  final String advice;
  final int adviceId;

  FavoritesEvent({required this.advice, required this.adviceId});
}

final class FavoritesAdviceAdded extends FavoritesEvent {
  FavoritesAdviceAdded({required super.advice, required super.adviceId});
}

final class FavoritesAdviceRemoved extends FavoritesEvent {
  FavoritesAdviceRemoved({required super.advice, required super.adviceId});
}
