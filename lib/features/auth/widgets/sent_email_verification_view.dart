import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';

class SentEmailVerificationView extends StatelessWidget {
  const SentEmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "We've sent you an email with verification link. Please use the link to verify your email.",
            ),
            TextButton(
              onPressed:
                  () => context.read<AuthBloc>().add(const AuthEventLogOut()),
              child: const Text('Back to Login screen'),
            ),
            TextButton(
              onPressed:
                  () => context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  ),
              child: const Text("Don't have verification email? Send again."),
            ),
          ],
        ),
      ),
    );
  }
}
