import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDataSource _adviceRemoteDataSource =
      AdviceRemoteDataSourceImpl();

  @override
  Future<Either<AdviceEntity, Failure>> getAdviceFromDataSource() async {
    final advice = await _adviceRemoteDataSource.getRandomAdviceFromApi();
    return left(advice);
    // handle expection to return right(failure)
  }
}
