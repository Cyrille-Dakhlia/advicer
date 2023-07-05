import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/repositories/advice_repo_impl.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:adviser/2_application/pages/adviser/bloc/adviser_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void setup() {
  // ! Application Layer
  getIt.registerFactory(() => AdviserBloc(adviceUseCases: getIt()));

  // ! Domain Layer
  getIt.registerFactory(() => AdviceUseCases(adviceRepo: getIt()));

  // ! Data Layer
  getIt.registerFactory<AdviceRepo>(
      () => AdviceRepoImpl(adviceRemoteDataSource: getIt()));
  getIt.registerFactory<AdviceRemoteDataSource>(
      () => AdviceRemoteDataSourceImpl(client: getIt()));

  // ! External
  getIt.registerFactory(() => http.Client());
}
