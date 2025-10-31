import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/auth_provider.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      emit(const AuthStateLoggedOut());
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.registerWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
      } catch (e) {
        print(e);
      }
      emit(const AuthStateNeedVerification());
    });

    on<AuthEventWantToRegister>(
      (event, emit) => emit(const AuthStateRegistering()),
    );

    on<AuthEventLogOut>((event, emit) async {
      try {
        provider.logOut();
      } catch (e) {
        print(e);
      }
      emit(const AuthStateLoggedOut());
    });
  }
}
