import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dwell_fi_assignment/core/notification/custom_notification_provider.dart';
import 'package:dwell_fi_assignment/core/notification/notification_service.dart';
import 'package:dwell_fi_assignment/core/socket/socket_service.dart';
import 'package:dwell_fi_assignment/features/auth/data/auth_repository_impl.dart';
import 'package:dwell_fi_assignment/features/auth/domain/auth_repository.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/data/file_repository_impl.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_repository.dart';
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

  String userId = await serviceLocator<AuthRepository>().getUserId();

  serviceLocator.registerLazySingleton<HomePageRepository>(
    () => HomePageRepositoryImpl(),
  );

  serviceLocator.registerSingleton<SocketService>(
    SocketServiceImpl('ws://localhost:8000/notification/events?user_id=$userId'),
  );

  serviceLocator.registerLazySingleton<FileRepository>(
    () => FileRepositoryImpl(),
  );

  // blocs
  serviceLocator.registerLazySingleton<HomeBloc>(
    () => HomeBloc(serviceLocator())..add(LoadFilesEvent()),
  );
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(serviceLocator()),
  );

  // serviceLocator.registerLazySingleton<FileBloc>(
  //   () => FileBloc(serviceLocator()),
  // );

  // services
  serviceLocator.registerLazySingleton<NotificationManager>(
    () => NotificationManager(),
  );

  serviceLocator.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(),
  );
}
