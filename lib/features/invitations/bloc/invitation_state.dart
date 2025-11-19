import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/invitations/data/invitation.dart';

@immutable
abstract class InvitationState {
  const InvitationState();
}

class InvitationStateWaiting extends InvitationState {
  const InvitationStateWaiting();
}

class InvitationStateReceived extends InvitationState {
  final bool isLoading;
  final Invitation? invitation;
  final Exception? exception;

  const InvitationStateReceived({
    required this.isLoading,
    this.invitation,
    this.exception,
  });
}

class InvitationStateAccepted extends InvitationState {
  const InvitationStateAccepted();
}

class InvitationStateRejected extends InvitationState {
  const InvitationStateRejected();
}
