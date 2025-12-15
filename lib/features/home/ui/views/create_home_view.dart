import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_event.dart';

class CreateHomeView extends StatefulWidget {
  const CreateHomeView({super.key});

  @override
  State<CreateHomeView> createState() => _CreateHomeViewState();
}

class _CreateHomeViewState extends State<CreateHomeView> {
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
        title: const Text('Create your home'),
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
              "You're not a member of any home. If you want to create your home, please choose your home's name and submit. If you want to join an existing home, then ask owner to send you an invitation link and click it.",
            ),
            TextField(
              controller: _name,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Enter home name here'),
            ),
            TextButton(
              onPressed:
                  () => context.read<HomeBloc>().add(
                    HomeEventCreateHome(homeName: _name.text),
                  ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
