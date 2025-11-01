import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/auth_provider.dart';
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
        emit(const AuthStateNeedVerification());
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.createUser(email: event.email, password: event.password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedVerification());
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
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
          emit(const AuthStateNeedVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventGoogleLogIn>((event, emit) async {
      try {
        await provider.googleLogIn();
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        provider.logOut();
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
      emit(const AuthStateLoggedOut());
    });

    on<AuthEventSendEmailVerification>((event, emit) {
      try {
        provider.sendEmailVerification();
        emit(const AuthStateNeedVerification());
      } on Exception catch (e) {
        emit(AuthStateNeedVerification(exception: e));
      }
    });
  }
}
