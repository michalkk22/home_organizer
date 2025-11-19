import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/data/auth_provider.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/data/auth_user.dart';
import 'package:home_organizer/utils/injection/repositories_injection.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(isLoading: false));
      } else if (!user.isEmailVerified) {
        _sendEmailVerification(provider, emit);
      } else {
        _setupReposAndLogIn(user, emit);
      }
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        emit(AuthStateRegistering(isLoading: true));
        await provider.createUser(email: event.email, password: event.password);
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
        return;
      }

      try {
        emit(const AuthStateNeedVerification(isLoading: true));
        await provider.sendEmailVerification();
        emit(const AuthStateNeedVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
        return;
      }
    });

    on<AuthEventWantToRegister>(
      (event, emit) => emit(const AuthStateRegistering(isLoading: false)),
    );

    on<AuthEventLogIn>((event, emit) async {
      try {
        emit(AuthStateLoggedOut(isLoading: true, loadingText: 'Logging in...'));
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        if (!user.isEmailVerified) {
          _sendEmailVerification(provider, emit);
        } else {
          _setupReposAndLogIn(user, emit);
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
        return;
      }
    });

    on<AuthEventGoogleLogIn>((event, emit) async {
      try {
        emit(
          AuthStateLoggedOut(
            isLoading: true,
            loadingText: 'Logging in with Google...',
          ),
        );
        final user = await provider.googleLogIn();
        if (!user.isEmailVerified) {
          _sendEmailVerification(provider, emit);
        } else {
          _setupReposAndLogIn(user, emit);
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
        return;
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        RepositoriesInjection().reset();
        emit(const AuthStateLoggedOut(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
        return;
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) {
      _sendEmailVerification(provider, emit);
    });

    on<AuthEventResetPassword>((event, emit) async {
      emit(const AuthStateResetPassword(didSendEmail: false, isLoading: false));
      final email = event.email;
      if (email == null) {
        return;
      }

      try {
        emit(
          const AuthStateResetPassword(didSendEmail: false, isLoading: true),
        );
        await provider.resetPassword(email: email);
      } on Exception catch (e) {
        emit(
          AuthStateResetPassword(
            didSendEmail: false,
            exception: e,
            isLoading: false,
          ),
        );
        return;
      }
      emit(const AuthStateResetPassword(didSendEmail: true, isLoading: false));
    });
  }

  void _setupReposAndLogIn(AuthUser user, Emitter<AuthState> emit) {
    RepositoriesInjection().setupUserScopedRepositories(user.id);
    emit(AuthStateLoggedIn(user: user, isLoading: false));
  }

  Future<void> _sendEmailVerification(
    AuthProvider provider,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthStateNeedVerification(isLoading: true));
      await provider.sendEmailVerification();
      emit(const AuthStateNeedVerification(isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }
}
