import 'package:adviser/1_domain/entities/advice_entity.dart';

abstract class AdviceRepo {
  Future<AdviceEntity> getAdviceFromDataSource();
}
