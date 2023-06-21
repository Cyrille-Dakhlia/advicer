import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/widgets/advice_field.dart';
import 'package:adviser/2_application/pages/adviser/widgets/custom_button.dart';
import 'package:adviser/2_application/pages/adviser/widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdviserPage extends StatelessWidget {
  const AdviserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adviser',
          style: themeData.textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: context.watch<ThemeService>().isDarkModeOn,
            onChanged: (_) => context.read<ThemeService>().toggleTheme(),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AdviceField(
                    advice:
                        'Therefore do not worry about tomorrow, for tomorrow will worry about its own things. Sufficient for the day is its own trouble.'),
                // child: ErrorMessage(message: 'oups, something\' got wrong!'),
/*                 child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary,
                ),
 */
              ),
            ),
            SizedBox(height: 100),
            CustomButton(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
