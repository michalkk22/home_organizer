import 'package:get_it/get_it.dart';
import 'package:home_organizer/features/chat/data/chat_repository.dart';
import 'package:home_organizer/features/chat/data/firebase_chat_repository.dart';
import 'package:home_organizer/features/home/data/repositories/firebase_homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/firebase_permissions_repository.dart';
import 'package:home_organizer/features/home/data/repositories/firebase_users_repository.dart';
import 'package:home_organizer/features/home/data/repositories/homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/features/invitations/data/firebase_invitations_repository.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

/// Make sure to call setupInitialRepositories() before other setup functions
class RepositoriesInjection {
  final getIt = GetIt.instance;

  void setupUserScopedRepositories(String userId) {
    final usersRepository = FirebaseUsersRepository(userId);
    final permissionsRepository = FirebasePermissionsRepository();
    getIt.registerSingleton<UsersRepository>(usersRepository);
    getIt.registerSingleton<HomesRepository>(
      FirebaseHomesRepository(userId, usersRepository, permissionsRepository),
    );
    getIt.registerSingleton<InvitationsRepository>(
      FirebaseInvitationsRepository(
        userId,
        getIt<UsersRepository>(),
        getIt<HomesRepository>(),
      ),
    );
  }

  void setupHomeScopedRepositories(String userId, String homeId) {
    getIt.registerLazySingleton<ChatRepository>(
      () => FirebaseChatRepository(userId, homeId, getIt<UsersRepository>()),
    );
  }

  void reset() {
    getIt.reset();
  }
}
