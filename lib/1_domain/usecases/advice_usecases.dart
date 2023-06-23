import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceUseCases {
  final AdviceRepo _adviceRepo;

  AdviceUseCases({required AdviceRepo adviceRepo}) : _adviceRepo = adviceRepo;

  Future<Either<AdviceEntity, Failure>> getAdvice() async {
    // business logic should be done here
    return _adviceRepo.getAdviceFromDataSource();
  }
}
