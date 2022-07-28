import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foods_app/common/utils/utility.dart';
import 'package:foods_app/screens/map_screen.dart';

import '../blocs/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/vector.jpg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ],
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 30),
                LoginTextField(
                  hintText: 'Email ID',
                  controller: email,
                  leading: Text(
                    '@',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                LoginTextField(
                  hintText: 'Password',
                  controller: password,
                  leading: Text(
                    '🔒',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0749ff),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthErrorState) {
                      showSnackBar(context, state.message);
                    }
                    if (state is AuthSignedInState) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, MapScreen.routeName, (route) => false);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff0749ff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                    email: email.text, password: password.text),
                              );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(text: 'New to App ? ', children: [
                        TextSpan(
                          text: 'Sign Up ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              log('Navigate to Login');
                            },
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0749ff),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget leading;
  const LoginTextField({
    Key? key,
    required this.controller,
    required this.leading,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
