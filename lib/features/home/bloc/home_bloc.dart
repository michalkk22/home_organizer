import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_event.dart';
import 'package:home_organizer/features/home/bloc/home_state.dart';
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/features/home/data/repositories/homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/core/injection/repositories_injection.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    UsersRepository users,
    HomesRepository homes,
    InvitationsRepository invitations,
  ) : super(const HomeStateLoading()) {
    on<HomeEventLoggedIn>((event, emit) async {
      User? user = await users.user;
      if (user == null) {
        emit(HomeStateNeedUserName(isLoading: false));
        return;
      }
      Home? home = await homes.home;
      if (home == null) {
        emit(HomeStateNoHomes(isLoading: false));
        return;
      }
      RepositoriesInjection().setupHomeScopedRepositories(user.id, home.id);
      emit(HomeStateInHome(isLoading: false, user: user, home: home));
    });

    on<HomeEventSetName>((event, emit) async {
      try {
        emit(HomeStateNeedUserName(isLoading: true));
        await users.setName(event.userName);
      } on Exception catch (e) {
        emit(HomeStateNeedUserName(isLoading: false, exception: e));
        return;
      }
      add(HomeEventLoggedIn());
    });

    on<HomeEventCreateHome>((event, emit) async {
      try {
        emit(HomeStateNeedUserName(isLoading: true));
        await homes.create(event.homeName);
      } on Exception catch (e) {
        emit(HomeStateNeedUserName(isLoading: false, exception: e));
        return;
      }
      add(HomeEventLoggedIn());
    });

    on<HomeEventInvite>((event, emit) async {
      if (state is HomeStateInHome) {
        final inHome = state as HomeStateInHome;
        try {
          emit(
            HomeStateInHome(
              isLoading: true,
              user: inHome.user,
              home: inHome.home,
            ),
          );
          final invitationLink = await invitations.createOrGet();
          emit(
            HomeStateInHome(
              isLoading: false,
              user: inHome.user,
              home: inHome.home,
              invitationLink: invitationLink,
            ),
          );
        } on Exception catch (e) {
          emit(
            HomeStateInHome(
              isLoading: false,
              user: inHome.user,
              home: inHome.home,
              exception: e,
            ),
          );
        }
      }
    });
  }
}
