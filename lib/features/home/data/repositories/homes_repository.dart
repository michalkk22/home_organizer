import 'package:home_organizer/features/home/data/models/home.dart';

abstract class HomesRepository {
  Future<Home?> get home;
  Future<Home> create(String name);
  Future<String?> getName(String id);
}
