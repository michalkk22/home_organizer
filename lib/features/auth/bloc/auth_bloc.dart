import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/data/auth_provider.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        _sendEmailVerification(provider, emit);
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.createUser(email: event.email, password: event.password);
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
      try {
        await provider.sendEmailVerification();
        emit(const AuthStateNeedVerification());
      } on Exception catch (e) {
        emit(AuthStateNeedVerification(exception: e));
      }
    });

    on<AuthEventWantToRegister>(
      (event, emit) => emit(const AuthStateRegistering()),
    );

    on<AuthEventLogIn>((event, emit) async {
      try {
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        if (!user.isEmailVerified) {
          _sendEmailVerification(provider, emit);
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventGoogleLogIn>((event, emit) async {
      try {
        final user = await provider.googleLogIn();
        if (!user.isEmailVerified) {
          _sendEmailVerification(provider, emit);
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        print('AuthBloc: logout succeeded');
        emit(const AuthStateLoggedOut());
        print('AuthBloc: emitted LoggedOut');
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) {
      _sendEmailVerification(provider, emit);
    });

    on<AuthEventResetPassword>((event, emit) {
      emit(const AuthStateResetPassword(didSendEmail: false));
      final email = event.email;
      if (email == null) {
        return;
      }

      try {
        provider.resetPassword(email: email);
      } on Exception catch (e) {
        emit(AuthStateResetPassword(didSendEmail: false, exception: e));
      }
      emit(const AuthStateResetPassword(didSendEmail: true));
    });
  }

  Future<void> _sendEmailVerification(
    AuthProvider provider,
    Emitter<AuthState> emit,
  ) async {
    try {
      await provider.sendEmailVerification();
      emit(const AuthStateNeedVerification());
    } on Exception catch (e) {
      emit(AuthStateNeedVerification(exception: e));
    }
  }
}
