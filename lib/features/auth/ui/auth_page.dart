import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/ui/views/login_view.dart';
import 'package:home_organizer/features/auth/ui/views/register_view.dart';
import 'package:home_organizer/features/auth/ui/views/reset_password_view.dart';
import 'package:home_organizer/features/auth/ui/views/sent_email_verification_view.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_event.dart';
import 'package:home_organizer/features/home/data/repositories/firebase_users_repository.dart';
import 'package:home_organizer/features/home/ui/home_page.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return BlocProvider(
            create:
                (context) =>
                    HomeBloc(FirebaseUsersRepository(userId: state.user.id))
                      ..add(HomeEventLoggedIn()),
            child: HomePage(),
          );
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedVerification) {
          return const SentEmailVerificationView();
        } else if (state is AuthStateResetPassword) {
          return ResetPasswordView(didSendEmail: state.didSendEmail);
        }
        return Container();
      },
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText);
        } else {
          LoadingScreen().hide();
        }
      },
    );
  }
}
