import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/core/deep_link/deep_link_handler.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/auth/data/firebase_auth_provider.dart';
import 'package:home_organizer/features/auth/ui/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(
    BlocProvider<AuthBloc>(
      create:
          (_) => AuthBloc(FirebaseAuthProvider())..add(AuthEventInitialize()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final deepLinks = DeepLinkHandler();

  @override
  Future<void> initState() async {
    await deepLinks.init(context);
    super.initState();
  }

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
