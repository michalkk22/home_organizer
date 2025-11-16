import 'package:home_organizer/features/home/data/models/user.dart';

abstract class UsersRepository {
  Future<User?> get user;
  Future<User?> getById(String name);
  Future<User> setName(String name);
}
