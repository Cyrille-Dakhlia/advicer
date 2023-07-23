import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:adviser/2_application/core/widgets/advice_field.dart';
import 'package:adviser/injection.dart';
import 'package:flutter/material.dart';

class DismissibleAdviceField extends StatelessWidget {
  const DismissibleAdviceField(
      {super.key, required this.advice, required this.adviceId});
  final String advice;
  final int adviceId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) => getIt<FavoritesBloc>()
          .add(FavoritesAdviceRemoved(advice: advice, adviceId: adviceId)),
      child: AdviceField(advice: advice),
    );
  }
}
