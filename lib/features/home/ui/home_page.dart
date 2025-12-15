import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home_organizer/features/chat/bloc/chat_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_event.dart';
import 'package:home_organizer/features/chat/data/chat_repository.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenditure_categories_repository.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenses_repository.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_state.dart';
import 'package:home_organizer/features/home/domain/homes_repository_exception.dart';
import 'package:home_organizer/features/home/domain/users_repository_exception.dart';
import 'package:home_organizer/features/home/ui/views/create_home_view.dart';
import 'package:home_organizer/features/home/ui/views/home_view.dart';
import 'package:home_organizer/features/home/ui/views/set_username_view.dart';
import 'package:home_organizer/features/invitations/domain/invitations_repository_exception.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/data/shopping_repository.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeStateInHome) {
          final getIt = GetIt.instance;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (context) =>
                        ChatBloc(getIt<ChatRepository>())..add(ChatEventLoad()),
              ),
              BlocProvider(
                create:
                    (context) => ExpensesBloc(
                      getIt<ExpensesRepository>(),
                      getIt<ExpenditureCategoriesRepository>(),
                    )..add(ExpensesEventLoad()),
              ),
              BlocProvider(
                create:
                    (context) =>
                        ShoppingBloc(getIt<ShoppingRepository>())
                          ..add(ShoppingEventLoad()),
              ),
            ],
            child: HomeView(),
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

        if (state.exception != null) {
          // in home exceptions
          if (state.exception is HomeNotFoundInvitationsRepositoryException) {
            showErrorDialog(context, 'You must select home first.');
          } else if (state.exception
              is CouldNotCreateInvitationsRepositoryException) {
            showErrorDialog(context, "Couldn't create your invitation");
          } else if (state.exception is GenericInvitationsRepositoryException) {
            showErrorDialog(context, "Couldn't find your invitation data");
            // no home exceptions
          } else if (state.exception is InvalidNameHomesRepositoryException) {
            showErrorDialog(
              context,
              'Home name must consist of at least 4 valid characters.',
            );
          } else if (state.exception
              is CouldNotCreateHomesRepositoryException) {
            showErrorDialog(context, "Couldn't create home");
          } else if (state.exception
              is CouldNotRetrieveDataHomesRepositoryException) {
            showErrorDialog(context, "Couldn't retrieve home data");
            // need user name exceptions
          } else if (state.exception is InvalidNameUsersRepositoryException) {
            showErrorDialog(
              context,
              'User name must consist of at least 4 valid characters.',
            );
          } else if (state.exception
              is CouldNotRetrieveDataUsersRepositoryException) {
            showErrorDialog(context, "Couldn't retrieve user data");
            // other exceptions
          } else {
            showErrorDialog(context, 'Unknown error');
          }
        }

        if (state is HomeStateInHome) {
          if (state.invitationLink != null) {
            final link = state.invitationLink!;
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Invitation link'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Send this link to peaple you want to invite!'),
                        SizedBox(height: 20),
                        SelectableText(link),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: link));
                        },
                        child: Text('Copy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Got It'),
                      ),
                    ],
                  ),
            );
          }
        }
      },
    );
  }
}
