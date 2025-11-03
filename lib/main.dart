import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/firebase_auth_provider.dart';
import 'package:home_organizer/features/auth/widgets/login_view.dart';
import 'package:home_organizer/features/auth/widgets/register_view.dart';
import 'package:home_organizer/features/auth/widgets/reset_password_view.dart';
import 'package:home_organizer/features/auth/widgets/sent_email_verification_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) =>
                  AuthBloc(FirebaseAuthProvider())..add(AuthEventInitialize()),
        ),
      ],
      child: MaterialApp(
        title: 'Home Organizer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedVerification) {
          return const SentEmailVerificationView();
        } else if (state is AuthStateResetPassword) {
          return ResetPasswordView(didSendEmail: state.didSendEmail);
        } else if (state is AuthStateLoggedIn) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Home Organizer'),
              backgroundColor: Colors.blue,
              leading: Icon(Icons.wheelchair_pickup),
              actions: [
                IconButton(
                  onPressed:
                      () => context.read<AuthBloc>().add(AuthEventLogOut()),
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Text('LOGGED'),
          );
        }
        return Scaffold(body: CircularProgressIndicator());
      },
      listener: (context, state) {},
    );
  }
}
