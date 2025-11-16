import 'package:home_organizer/features/home/data/models/user.dart';

abstract class UsersRepository {
  Future<User> get();
  Future<User> setName(String name);
}
