import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_event.dart';

class SetUsernameView extends StatefulWidget {
  const SetUsernameView({super.key});

  @override
  State<SetUsernameView> createState() => _SetUsernameViewState();
}

class _SetUsernameViewState extends State<SetUsernameView> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set your name'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(AuthEventLogOut()),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Please choose your name. This will be displayed as your name to other users. You will be able to chenge it later',
            ),
            TextField(
              controller: _name,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Enter your name here'),
            ),
            TextButton(
              onPressed:
                  () => context.read<HomeBloc>().add(
                    HomeEventSetName(userName: _name.text),
                  ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
