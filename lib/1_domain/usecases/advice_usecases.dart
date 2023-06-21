import 'package:adviser/1_domain/entities/advice_entity.dart';

class AdviceUseCases {
  Future<AdviceEntity> getAdvice() async {
    // business logic should be done here
    await Future.delayed(const Duration(seconds: 3));
    return const AdviceEntity(
        advice: 'Fake advice fasely retrieved from fake API.', id: 1);
  }
}
