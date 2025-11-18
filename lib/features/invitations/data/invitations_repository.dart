import 'package:home_organizer/features/invitations/data/invitation.dart';

abstract class InvitationsRepository {
  Future<String> createInvitation();
  Future<Invitation> get(String id);
  Future<void> accept(String id);
}
