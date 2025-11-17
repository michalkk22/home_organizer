import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home_organizer/features/chat/bloc/chat_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_event.dart';
import 'package:home_organizer/features/chat/data/chat_repository.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_state.dart';
import 'package:home_organizer/features/home/ui/views/create_home_view.dart';
import 'package:home_organizer/features/home/ui/views/home_view.dart';
import 'package:home_organizer/features/home/ui/views/set_username_view.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeStateInHome) {
          final getIt = GetIt.instance;
          return BlocProvider(
            create:
                (context) =>
                    ChatBloc(getIt<ChatRepository>())..add(ChatEventLoad()),
            child: HomeView(home: state.home),
          );
        } else if (state is HomeStateNeedUserName) {
          return SetUsernameView();
        } else if (state is HomeStateNoHomes) {
          return CreateHomeView();
        }
        return Center(child: CircularProgressIndicator());
      },
      listener: (BuildContext context, HomeState state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: '');
        } else {
          LoadingScreen().hide();
        }
      },
    );
  }
}
