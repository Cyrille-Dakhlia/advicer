import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDataSource _adviceRemoteDataSource;

  AdviceRepoImpl({required AdviceRemoteDataSource adviceRemoteDataSource})
      : _adviceRemoteDataSource = adviceRemoteDataSource;

  @override
  Future<Either<AdviceEntity, Failure>> getAdviceFromDataSource() async {
    // we can check here if we have an Internet connection to choose the datasource (remote or local)
    try {
      final adviceModel =
          await _adviceRemoteDataSource.getRandomAdviceFromApi();
      return left(AdviceEntity(advice: adviceModel.advice, id: adviceModel.id));
    } on ServerException catch (_) {
      return right(ServerFailure());
    } on CacheException catch (_) {
      return right(CacheFailure());
    } catch (_) {
      return right(GeneralFailure());
    }
  }
}
