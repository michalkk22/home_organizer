import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_event.dart';
import 'package:home_organizer/features/chat/ui/chat_page.dart';
import 'package:home_organizer/features/expenses/ui/expenses_page.dart';
import 'package:home_organizer/features/home/data/models/home.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.home});
  final Home home;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              home.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: Icon(Icons.wheelchair_pickup),
            actions: [
              IconButton(
                onPressed:
                    () => context.read<AuthBloc>().add(AuthEventLogOut()),
                icon: Icon(Icons.logout),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.message)),
                Tab(icon: Icon(Icons.wallet)),
              ],
            ),
          ),
          body: TabBarView(children: [ChatPage(), ExpensesPage()]),
        ),
      ),
    );
  }
}
