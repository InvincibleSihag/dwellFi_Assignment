import 'dart:io';

import 'package:dwell_fi_assignment/features/auth/data/auth_repository_impl.dart';
import 'package:dwell_fi_assignment/features/auth/domain/auth_repository.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/data/repository/home_page_repository_impl.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;
final currentPlatform = Platform.operatingSystem;

Future<void> initDependencies() async {

  // repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  serviceLocator.registerLazySingleton<HomePageRepository>(
    () => HomePageRepositoryImpl(),
  );

  // blocs
  serviceLocator.registerLazySingleton<HomeBloc>(
    () => HomeBloc(serviceLocator())..add(LoadFilesEvent()),
  );
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(serviceLocator()),
  );
}
 