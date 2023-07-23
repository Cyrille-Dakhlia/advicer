import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:adviser/2_application/pages/adviser/widgets/clickable_advice_field.dart';
import 'package:adviser/2_application/pages/adviser/widgets/custom_button.dart';
import 'package:adviser/2_application/pages/adviser/widgets/error_message.dart';
import 'package:adviser/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdviserPageWrapperProvider extends StatelessWidget {
  const AdviserPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AdviserBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<FavoritesBloc>(),
        ),
      ],
      child: const AdviserPage(),
    );
  }
}

class AdviserPage extends StatelessWidget {
  static const initialAdviceMessage =
      'Press the button to get your first advice.';

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
                  builder: (context, state) => switch (state) {
                    AdviserInitial() => Text(
                        initialAdviceMessage,
                        style: themeData.textTheme.bodyMedium,
                      ),
                    AdviserLoadInProgress() => CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                      ),
                    AdviserLoadFailure(message: var message) =>
                      ErrorMessage(message: message),
                    AdviserLoadSuccess(
                      advice: var advice,
                      adviceId: var adviceId
                    ) =>
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, favoritesState) {
                          final isFavorite = favoritesState.favorites
                              .any((advice) => advice.id == adviceId);
                          return ClickableAdviceField(
                            isFavorite: isFavorite,
                            advice: advice,
                            onPressed: () => context.read<FavoritesBloc>().add(
                                  (!isFavorite)
                                      ? FavoritesAdviceAdded(
                                          advice: advice, adviceId: adviceId)
                                      : FavoritesAdviceRemoved(
                                          advice: advice, adviceId: adviceId),
                                ),
                          );
                        },
                      ),
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
