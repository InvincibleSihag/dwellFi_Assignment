import 'dart:io';

import 'package:dwell_fi_assignment/core/notification/notification_service.dart';
import 'package:dwell_fi_assignment/core/socket/socket_service.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/pages/login_page.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/entities.dart' as file_entities;
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/home_page.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  serviceLocator<SocketService>();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    serviceLocator<SocketService>()
        .getStream("Notification")
        .listen((onData) {
      // print(onData);
      file_entities.Notification notification = file_entities.Notification.fromJson(onData);
      if (Platform.isAndroid || Platform.isIOS) {
        serviceLocator<LocalNotificationService>().showNotification(notification.title, notification.description);
      } else {
        serviceLocator<LocalNotificationService>().showCustomNotification(context, notification.title, notification.description);
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<HomeBloc>()),
        BlocProvider(create: (context) => serviceLocator<FileBloc>()),
      ],
      child: MaterialApp(
        title: 'Dwell FI Assignment',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}
