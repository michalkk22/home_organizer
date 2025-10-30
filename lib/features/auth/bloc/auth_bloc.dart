import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/auth_provider.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoggedOut()) {}
}
