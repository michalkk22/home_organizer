import 'package:flutter/material.dart';

class EmailAndPasswordForm extends StatefulWidget {
  const EmailAndPasswordForm({
    super.key,
    required this.buttonText,
    required this.callback,
    this.confirmPassword = false,
  });
  final String buttonText;
  final void Function(String email, String password) callback;
  final bool confirmPassword;

  @override
  State<EmailAndPasswordForm> createState() => _EmailAndPasswordFormState();
}

class _EmailAndPasswordFormState extends State<EmailAndPasswordForm> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirmation;
  late final FocusNode _passwordFocus;
  bool _confirmationCorrect = true;
  bool _confirmationCheck() {
    setState(() {
      _confirmationCorrect = _password.text == _passwordConfirmation.text;
    });
    return _confirmationCorrect;
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    if (widget.confirmPassword) {
      _passwordConfirmation = TextEditingController();
      _passwordFocus =
          FocusNode()..addListener(() {
            if (!_passwordFocus.hasFocus) {
              _confirmationCheck();
            }
          });
    }
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    if (widget.confirmPassword) {
      _passwordConfirmation.dispose();
      _passwordFocus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
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
          focusNode: widget.confirmPassword ? _passwordFocus : null,
          onChanged:
              !widget.confirmPassword
                  ? null
                  : _passwordConfirmation.text != ''
                  ? (_) => _confirmationCheck()
                  : null,
        ),
        if (widget.confirmPassword)
          TextField(
            controller: _passwordConfirmation,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm your password',
              error:
                  _confirmationCorrect
                      ? null
                      : Text(
                        "Password confirmation doesn't match password",
                        style: TextStyle(color: Colors.red),
                        maxLines: 1,
                      ),
            ),
            onChanged: (_) => _confirmationCheck(),
          ),
        TextButton(
          onPressed:
              () =>
                  !widget.confirmPassword || _confirmationCheck()
                      ? widget.callback(_email.text, _password.text)
                      : showDialog(
                        context: context,
                        builder:
                            (context) => Dialog(
                              child: Text(
                                "Password confirmation doesn't match password",
                              ),
                            ),
                      ),
          child: Text(widget.buttonText),
        ),
      ],
    );
  }
}
