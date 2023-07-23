import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/repositories/advice_repo_impl.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:adviser/2_application/core/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void setup() {
  // ! External
  getIt.registerFactory(() => http.Client());

  // ! Data Layer
  getIt.registerFactory<AdviceRemoteDataSource>(
      () => AdviceRemoteDataSourceImpl(client: getIt()));
  getIt.registerFactory<AdviceRepo>(
      () => AdviceRepoImpl(adviceRemoteDataSource: getIt()));

  // ! Domain Layer
  getIt.registerFactory(() => AdviceUseCases(adviceRepo: getIt()));

  // ! Application Layer
  getIt.registerFactory(() => AdviserBloc(adviceUseCases: getIt()));
  //NOTE:XXX: the registration order matters when registering Singleton (probably not lazy instanciation because it needs AdviceUseCases to be already registered)
  getIt.registerSingleton(FavoritesBloc(adviceUseCases: getIt()));
}
