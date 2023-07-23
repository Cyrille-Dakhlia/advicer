import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AdviceRepo {
  Future<Either<AdviceEntity, Failure>> getAdviceFromDataSource();

  Future<bool> updateFavoritesInDataSource(List<AdviceEntity> updatedList);
}
