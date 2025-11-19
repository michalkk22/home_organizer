import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class InvitationEvent {
  const InvitationEvent();
}

class InvitationEventReceive extends InvitationEvent {
  final String invitationId;

  const InvitationEventReceive({required this.invitationId});
}

class InvitationEventAnswer extends InvitationEvent {
  final bool accept;

  const InvitationEventAnswer({required this.accept});
}

class InvitationEventDone extends InvitationEvent {
  const InvitationEventDone();
}
