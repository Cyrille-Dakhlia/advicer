import 'package:adviser/0_data/repositories/advice_repo_impl.dart';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceUseCases {
  final AdviceRepo _adviceRepoImpl = AdviceRepoImpl();

  Future<Either<AdviceEntity, Failure>> getAdvice() async {
    // business logic should be done here
    return _adviceRepoImpl.getAdviceFromDataSource();
  }
}
