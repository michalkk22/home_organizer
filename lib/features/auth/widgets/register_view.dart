import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/widgets/email_and_password_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            EmailAndPasswordForm(
              buttonText: 'Register',
              callback: (email, password) {
                context.read<AuthBloc>().add(
                  AuthEventRegister(email: email, password: password),
                );
              },
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
