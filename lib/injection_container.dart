import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/domain/use_cases/use_case.dart';
import 'core/network/network_info.dart';
import 'core/util/presentation/input_converter.dart';
import 'features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/entities/number_trivia.dart';
import 'features/number_trivia/domain/gateways/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

var sl = GetIt.instance;

Future<void> setup() async {
  //! Features - Number Trivia
  //! Bloc
  sl.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );
  // UseCases
  sl.registerLazySingleton<UseCase<NumberTrivia, Parameters>>(
    () => GetConcreteNumberTrivia(gateway: sl()),
  );
  sl.registerLazySingleton<UseCase<NumberTrivia, NoParameters>>(
    () => GetRandomNumberTrivia(gateway: sl()),
  );
  // Gateway
  sl.registerLazySingleton<NumberTriviaGateway>(
    () => NumberTriviaRepository(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data Source
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  // External
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => http.Client());
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);
}
