import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/invitations/data/invitation.dart';

@immutable
abstract class InvitationState {
  final Invitation? invitation;
  final bool isLoading;
  final String? loadingText;
  final Exception? exception;
  const InvitationState({
    this.invitation,
    required this.isLoading,
    this.loadingText,
    this.exception,
  });
}

class InvitationStateWaiting extends InvitationState {
  const InvitationStateWaiting() : super(isLoading: true);
}

class InvitationStateReceived extends InvitationState {
  const InvitationStateReceived({
    required super.isLoading,
    super.invitation,
    super.loadingText,
    super.exception,
  });
}

class InvitationStateAccepted extends InvitationState {
  const InvitationStateAccepted({required super.isLoading, super.exception});
}

class InvitationStateRejected extends InvitationState {
  const InvitationStateRejected({required super.isLoading, super.exception});
}
