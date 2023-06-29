import 'package:equatable/equatable.dart';

class AdviceModel extends Equatable {
  final String advice;
  final int id;
  const AdviceModel({required this.advice, required this.id});

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(advice: json['advice'], id: json['advice_id']);
  }

  @override
  List<Object?> get props => [advice, id];
}
