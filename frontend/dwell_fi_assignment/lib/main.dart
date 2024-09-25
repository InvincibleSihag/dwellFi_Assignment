import 'package:dwell_fi_assignment/config/theme.dart';
import 'package:dwell_fi_assignment/core/socket/socket_service.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/home_page.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        theme: baseTheme,
        navigatorKey: navigatorKey, // Set the navigator key here
        title: 'Dwell FI Assignment',
        home: const HomePage(),
      ),
    );
  }
}
