import 'package:home_organizer/features/invitations/data/invitation.dart';

abstract class InvitationsRepository {
  Future<String> createOrGet();
  Future<Invitation> get(String id);
  Future<void> accept(Invitation invitation);
  Stream<String> observeStatus(String invitationId);
}
