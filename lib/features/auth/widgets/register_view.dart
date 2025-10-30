import 'package:flutter/material.dart';
import 'package:home_organizer/features/auth/widgets/email_and_password_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          EmailAndPasswordForm(
            buttonText: 'Register',
            callback: (email, password) {
              // TODO: register logic
              print('$email $password');
            },
          ),
        ],
      ),
    );
  }
}
