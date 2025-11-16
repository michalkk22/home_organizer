import 'package:home_organizer/features/home/data/models/permissions.dart';

abstract class PermissionsRepository {
  Future<Permissions> get({required String homeId, required String userId});
}
