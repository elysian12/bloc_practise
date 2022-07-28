import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foods_app/screens/login_screens.dart';
import 'package:foods_app/screens/map_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  log(settings.name!);
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => LoginScreen(),
      );
    case '/':
      return null;
    case MapScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => MapScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => ErrorScreen(
          errorMessage: 'Something Went Wrong !!!',
        ),
      );
  }
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(errorMessage),
      ),
    );
  }
}
