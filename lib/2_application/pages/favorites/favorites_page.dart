import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:adviser/2_application/core/services/theme_service.dart';
import 'package:adviser/2_application/pages/adviser/widgets/advice_field.dart';
import 'package:adviser/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: themeData.textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          Switch(
              value: context.watch<ThemeService>().isDarkModeOn,
              onChanged: (_) => context.read<ThemeService>().toggleTheme())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
        //todo: add BlocListener to show snackbar if success or failure
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          bloc: getIt<FavoritesBloc>(),
          builder: (context, state) {
            return ListView.separated(
                itemBuilder: (context, index) =>
                    AdviceField(advice: state.favorites[index].advice),
                separatorBuilder: (_, __) => const Divider(
                      height: 30,
                      indent: 20,
                      endIndent: 20,
                      thickness: 2,
                      color: Colors.blueGrey,
                    ),
                itemCount: state.favorites.length);
          },
        ),
      ),
    );
  }
}
