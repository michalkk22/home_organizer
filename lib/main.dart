import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/data/firebase_auth_provider.dart';
import 'package:home_organizer/features/auth/ui/auth_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    BlocProvider<AuthBloc>(
      create:
          (_) => AuthBloc(FirebaseAuthProvider())..add(AuthEventInitialize()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Organizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
