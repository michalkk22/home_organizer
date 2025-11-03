import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';

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
    return Scaffold(
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
    );
  }
}
