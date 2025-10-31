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
            const Text('Please verify your email.'),
            TextButton(
              onPressed:
                  () => context.read<AuthBloc>().add(
                    const AuthEventWantToRegister(),
                  ),
              child: const Text('Back to Register sreen'),
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
