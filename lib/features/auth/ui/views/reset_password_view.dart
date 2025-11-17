import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/domain/auth_exception.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, required this.didSendEmail});
  final bool didSendEmail;

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(
                context,
                'This email is not valid. Please use a correct email.',
              );
            } else if (state.exception is UserNotFoundAuthException) {
              showErrorDialog(
                context,
                "User not found. Please use correct email or register if you don't have an account, yet.",
              );
            } else {
              showErrorDialog(context, 'Unknown error occured.');
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Forgot password')),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              widget.didSendEmail
                  ? Text(
                    "We've sent you an email with password reset link. Please use the link to reset your password.",
                  )
                  : Text('Enter your email to reset password.'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Enter your email here'),
              ),
              TextButton(
                onPressed:
                    () => context.read<AuthBloc>().add(
                      AuthEventResetPassword(email: _email.text),
                    ),
                child: Text('Reset password'),
              ),

              TextButton(
                onPressed:
                    () => context.read<AuthBloc>().add(const AuthEventLogOut()),
                child: const Text('Back to Login screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
