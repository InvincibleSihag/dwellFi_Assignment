import 'package:dwell_fi_assignment/features/auth/data/auth_repository_impl.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepositoryImpl())),
      ],
      child: MaterialApp(
        title: 'Dwell FI Assignment',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
