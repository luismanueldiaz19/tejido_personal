import 'package:flutter/material.dart';
import 'package:tejidos/src/home.dart';

import 'screens/sign_in_login.dart';
import 'screens/register_new_user.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const SignInLogin());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterNewUser());
      // case profile:
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
