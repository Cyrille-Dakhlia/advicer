import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AdviceModel extends Equatable {
  final String advice;
  final int id;
  const AdviceModel({required this.advice, required this.id});

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(advice: json['advice'], id: json['advice_id']);
  }

  factory AdviceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AdviceModel(
      advice: data?['advice'],
      id: data?['adviceId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'advice': advice,
      'adviceId': id,
    };
  }

  @override
  List<Object?> get props => [advice, id];
}
