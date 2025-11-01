import 'package:flutter/material.dart';

class EmailAndPasswordForm extends StatefulWidget {
  const EmailAndPasswordForm({
    super.key,
    required this.buttonText,
    required this.callback,
    required this.googleCallback,
  });
  final String buttonText;
  final void Function(String email, String password) callback;
  final void Function() googleCallback;

  @override
  State<EmailAndPasswordForm> createState() => _EmailAndPasswordFormState();
}

class _EmailAndPasswordFormState extends State<EmailAndPasswordForm> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'Enter your email here'),
        ),
        TextField(
          controller: _password,
          enableSuggestions: false,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Enter your password here'),
        ),
        TextButton(
          onPressed: () => widget.callback(_email.text, _password.text),
          child: Text(widget.buttonText),
        ),
        ElevatedButton(
          onPressed: widget.googleCallback,
          child: const Text('With Google'),
        ),
      ],
    );
  }
}
