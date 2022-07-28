import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foods_app/blocs/auth/auth_bloc.dart';
import 'package:foods_app/blocs/autocomplete/auto_complete_bloc.dart';
import 'package:foods_app/blocs/geolocation/geolocation_bloc.dart';
import 'package:foods_app/blocs/places/places_bloc.dart';
import 'package:foods_app/common/constants/theme.dart';
import 'package:foods_app/firebase_options.dart';
import 'package:foods_app/repositories/auth/auth_repository.dart';
import 'package:foods_app/router.dart';
import 'package:foods_app/screens/login_screens.dart';
import 'package:foods_app/screens/map_screen.dart';

import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => GeolocationRepository(),
        ),
        RepositoryProvider(
          create: (_) => PlacesRepository(),
        ),
        RepositoryProvider(
          create: (_) => AuthRepository(auth: FirebaseAuth.instance),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GeolocationBloc(
                geolocationRepository: context.read<GeolocationRepository>(),
              )..add(LoadGeolocationEvent()),
            ),
            BlocProvider(
              create: (context) => AutoCompleteBloc(
                placesRepository: context.read<PlacesRepository>(),
              )..add(LoadAutoCompleteEvent()),
            ),
            BlocProvider(
              create: (context) => PlacesBloc(
                placesRepository: context.read<PlacesRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              )..add(AuthStateChangeEvent()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Foods App',
            theme: appTheme(),
            onGenerateRoute: onGenerateRoute,
            home: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) => previous is AuthIntialState,
              builder: (context, state) {
                log(state.toString());
                if (state is UnAuthenticatedState) {
                  return LoginScreen();
                } else if (state is AuthenticatedState) {
                  return MapScreen();
                }
                return LoginScreen();
              },
            ),
          )),
    );
  }
}
