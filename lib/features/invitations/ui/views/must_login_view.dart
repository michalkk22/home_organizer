import 'package:flutter/material.dart';
import 'package:home_organizer/features/auth/ui/auth_page.dart';

class MustLoginView extends StatelessWidget {
  const MustLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'To accept an invitation you must log in first. Please log in and then click the link again.',
        ),
        TextButton(
          onPressed:
              () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthPage()),
                (route) => false,
              ),
          child: Text('Back to login'),
        ),
      ],
    );
  }
}
