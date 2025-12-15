import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/home/bloc/home_event.dart';
import 'package:home_organizer/features/home/bloc/home_state.dart';
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/features/home/data/repositories/homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/core/injection/repositories_injection.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late Home home;
  late User user;
  late Permissions permissions;
  HomeBloc(
    UsersRepository users,
    HomesRepository homes,
    InvitationsRepository invitations,
  ) : super(const HomeStateLoading()) {
    on<HomeEventLoggedIn>((event, emit) async {
      try {
        final currentUser = await users.user;
        if (currentUser == null) {
          emit(HomeStateNeedUserName(isLoading: false));
          return;
        }
        user = currentUser;

        final currentHome = await homes.home;
        if (currentHome == null) {
          emit(HomeStateNoHomes(isLoading: false));
          return;
        }
        home = currentHome;
        permissions = home.members[user]!;
        RepositoriesInjection().setupHomeScopedRepositories(
          currentUser.id,
          currentHome.id,
        );
        emit(HomeStateInHome(isLoading: false));
      } on Exception catch (e) {
        emit(HomeStateNoHomes(isLoading: false, exception: e));
      }
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
        emit(HomeStateNoHomes(isLoading: true));
        await homes.create(event.homeName);
      } on Exception catch (e) {
        emit(HomeStateNoHomes(isLoading: false, exception: e));
        return;
      }
      add(HomeEventLoggedIn());
    });

    on<HomeEventInvite>((event, emit) async {
      try {
        emit(HomeStateInHome(isLoading: true));
        final invitationLink = await invitations.createOrGet();
        emit(HomeStateInHome(isLoading: false, invitationLink: invitationLink));
      } on Exception catch (e) {
        emit(HomeStateInHome(isLoading: false, exception: e));
      }
    });
  }
}
