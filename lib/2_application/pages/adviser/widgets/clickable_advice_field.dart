import 'package:adviser/2_application/core/widgets/advice_field.dart';
import 'package:flutter/material.dart';

class ClickableAdviceField extends StatelessWidget {
  const ClickableAdviceField(
      {super.key,
      required this.advice,
      this.isFavorite = false,
      required this.onPressed});
  final String advice;
  final bool isFavorite;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 25,
            ),
            AdviceField(advice: advice),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: FloatingActionButton(
            mini: true,
            onPressed: onPressed,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ),
      ],
    );
  }
}
