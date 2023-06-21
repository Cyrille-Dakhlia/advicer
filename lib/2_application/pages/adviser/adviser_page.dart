import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:adviser/2_application/pages/adviser/widgets/advice_field.dart';
import 'package:adviser/2_application/pages/adviser/widgets/custom_button.dart';
import 'package:adviser/2_application/pages/adviser/widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdviserPageWrapperProvider extends StatelessWidget {
  const AdviserPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdviserBloc(),
      child: const AdviserPage(),
    );
  }
}

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<AdviserBloc, AdviserState>(
                  builder: (context, state) {
                    if (state is AdviserInitial) {
                      return Text(
                        'Press the button to get your first advice.',
                        style: themeData.textTheme.bodyMedium,
                      );
                    } else if (state is AdviserLoadInProgress) {
                      return CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                      );
                    } else if (state is AdviserLoadSuccess) {
                      return AdviceField(advice: state.advice);
                    } else if (state is AdviserLoadFailure) {
                      debugPrint(state.message);
                      return const ErrorMessage(
                          message: 'Hmmm, something\'s got wrong!');
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 100),
            CustomButton(
              onPressed: () =>
                  context.read<AdviserBloc>().add(AdviserRequestPressed()),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
