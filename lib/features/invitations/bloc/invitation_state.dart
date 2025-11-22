import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/invitations/data/invitation.dart';

@immutable
abstract class InvitationState {
  final bool isLoading;
  const InvitationState({required this.isLoading});
}

class InvitationStateWaiting extends InvitationState {
  const InvitationStateWaiting() : super(isLoading: true);
}

class InvitationStateReceived extends InvitationState {
  final Invitation? invitation;
  final Exception? exception;

  const InvitationStateReceived({
    required super.isLoading,
    this.invitation,
    this.exception,
  });
}

class InvitationStateAccepted extends InvitationState {
  const InvitationStateAccepted({required super.isLoading});
}

class InvitationStateRejected extends InvitationState {
  const InvitationStateRejected({required super.isLoading});
}
