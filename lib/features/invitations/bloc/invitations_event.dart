import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class InvitationsEvent {
  const InvitationsEvent();
}

class InvitationsEventAnswer extends InvitationsEvent {
  final bool accept;

  const InvitationsEventAnswer({required this.accept});
}
