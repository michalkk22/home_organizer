import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/features/home/data/models/home.dart';

abstract class HomesRepository {
  Future<Home?> get home;
  Future<Home> create(String name);
  Future<String?> getName(String id);
  Future<void> addMember(String homeId, String userId, WriteBatch batch);
}
