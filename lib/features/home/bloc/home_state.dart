import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomeState {
  final bool isLoading;
  const HomeState({required this.isLoading});
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading() : super(isLoading: true);
}

class HomeStateNeedUserName extends HomeState {
  final Exception? exception;
  const HomeStateNeedUserName({required super.isLoading, this.exception});
}

class HomeStateNoHomes extends HomeState {
  final Exception? exception;
  const HomeStateNoHomes({required super.isLoading, this.exception});
}

class HomeStateInHome extends HomeState {
  final String? invitationLink;
  final Exception? exception;
  const HomeStateInHome({
    required super.isLoading,
    this.invitationLink,
    this.exception,
  });
}
