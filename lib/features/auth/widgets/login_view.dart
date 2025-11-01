import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/widgets/email_and_password_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            EmailAndPasswordForm(
              buttonText: 'Login',
              callback: (email, password) {
                context.read<AuthBloc>().add(
                  AuthEventLogIn(email: email, password: password),
                );
              },
              googleCallback: () {
                context.read<AuthBloc>().add(AuthEventGoogleLogIn());
              },
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventWantToRegister());
              },
              child: const Text('Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
