import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  const CustomButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor:
            MaterialStatePropertyAll(themeData.colorScheme.secondary),
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
      ),
      child: Text(
        'Get Advice',
        style: themeData.textTheme.headlineSmall,
      ),
    );
  }
}
