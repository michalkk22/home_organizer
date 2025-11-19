import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/invitations/data/invitation.dart';

@immutable
abstract class InvitationsState {
  const InvitationsState();
}

class InvitationsStateWaiting extends InvitationsState {
  const InvitationsStateWaiting();
}

class InvitationsStateReceived extends InvitationsState {
  final Invitation invitation;
  final Exception? exception;

  const InvitationsStateReceived({required this.invitation, this.exception});
}
