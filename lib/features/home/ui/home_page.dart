import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Organizer',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Icon(Icons.wheelchair_pickup),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(AuthEventLogOut()),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Text('LOGGED'),
    );
  }
}
