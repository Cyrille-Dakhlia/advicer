import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class GeneralFailure extends Failure {}
