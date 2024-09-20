//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class AppRouter {
//   static const String loginRoute = '/auth';
//   static const String homeRoute = '/home';
//   static const String welcomeRoute = '/device_add';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case welcomeRoute:
//         return MaterialPageRoute(
//           builder: (context) => ChangeNotifierProvider(
//             child: const WelcomePage(),
//             create: (context) => WelcomeViewModel(),
//           ),
//         );
//       case loginRoute:
//         var args = {};
//         try {
//           args = settings.arguments as Map;
//         } on TypeError {}
//         return MaterialPageRoute(
//           builder: (context) => ChangeNotifierProvider(
//             child: const Login(),
//             create: (context) => LoginViewModel(registerState: args['registerState'] ?? false),
//           ),
//         );
//       case homeRoute:
//         return MaterialPageRoute(
//           builder: (context) => const HomePage(),
//         );
//       default:
//         return MaterialPageRoute(
//           builder: (context) => const WelcomePage(),
//           // builder: (context) => ChangeNotifierProvider(
//           //   child: const Login(),
//             // create: (context) => LoginViewModel(),
//           // ),
//         );
//     }
//   }
// }