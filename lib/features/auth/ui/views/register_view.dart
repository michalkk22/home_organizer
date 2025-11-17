import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/domain/auth_exception.dart';
import 'package:home_organizer/features/auth/ui/widgets/email_and_password_form.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          if (state.exception != null) {
            if (state.exception is EmailAlreadyInUseAuthException) {
              showErrorDialog(context, 'This email is already in use.');
            } else if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(
                context,
                'This email is not valid. Please use a correct email.',
              );
            } else if (state.exception is WeakPasswordAuthException) {
              showErrorDialog(
                context,
                'This password is too weak. Please use stronger password.',
              );
            } else if (state.exception is NewtowrkFailAuthException) {
              showErrorDialog(
                context,
                'Network error. Please check your internet connection',
              );
            } else {
              showErrorDialog(context, 'Unknown error occured.');
            }
          }
        }
      },
      child: Scaffold(
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
                confirmPassword: true,
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
      ),
    );
  }
}
