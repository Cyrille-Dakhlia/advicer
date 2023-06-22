import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';

class AdviceUseCases {
  Future<Either<AdviceEntity, Failure>> getAdvice() async {
    // business logic should be done here
    await Future.delayed(const Duration(seconds: 3));
    return left(const AdviceEntity(
        advice: 'Fake advice fasely retrieved from fake API.', id: 1));
    // we return right(...) when we get a failure from the repository
    // return right(ServerFailure());
  }
}
