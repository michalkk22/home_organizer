import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventLoggedIn extends HomeEvent {
  const HomeEventLoggedIn();
}

class HomeEventSetName extends HomeEvent {
  final String userName;

  const HomeEventSetName({required this.userName});
}

class HomeEventCreateHome extends HomeEvent {
  final String homeName;

  const HomeEventCreateHome({required this.homeName});
}
