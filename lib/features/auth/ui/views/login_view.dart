import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/domain/auth_exception.dart';
import 'package:home_organizer/features/auth/ui/widgets/email_and_password_form.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            if (state.exception is UserNotLoggedInAuthException) {
              showErrorDialog(context, 'Please log in.');
            } else if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(
                context,
                'This email is not valid. Please use a correct email.',
              );
            } else if (state.exception is UserNotFoundAuthException ||
                state.exception is WrongPasswordAuthException ||
                state.exception is InvalidCredentialAuthException) {
              showErrorDialog(
                context,
                "Please use correct credentials or register if you don't have an account, yet.",
              );
            } else if (state.exception is NewtowrkFailAuthException) {
              showErrorDialog(
                context,
                'Network error. Please check your internet connection',
              );
            } else if (state.exception is GoogleSignInAuthException) {
              showErrorDialog(context, 'Google login error.');
            } else if (state.exception is DifferentCredentialAuthException) {
              showErrorDialog(
                context,
                'This account already exists with defferent credentials.',
              );
            } else {
              showErrorDialog(context, 'Unknown error occured.');
            }
          }
        }
      },
      child: Scaffold(
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
              ),
              TextButton(
                onPressed:
                    () => context.read<AuthBloc>().add(AuthEventGoogleLogIn()),
                child: const Text('Use Google account'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventWantToRegister());
                },
                child: const Text('Register here'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventResetPassword());
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
