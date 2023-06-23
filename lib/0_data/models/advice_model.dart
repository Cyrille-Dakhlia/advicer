import 'package:adviser/1_domain/entities/advice_entity.dart';

class AdviceModel extends AdviceEntity {
  const AdviceModel({required super.advice, required super.id});

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(advice: json['advice'], id: json['advice_id']);
  }
}
