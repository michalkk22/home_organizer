import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomeState {
  final bool isLoading;
  final Exception? exception;
  const HomeState({required this.isLoading, this.exception});
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading() : super(isLoading: true);
}

class HomeStateNeedUserName extends HomeState {
  const HomeStateNeedUserName({required super.isLoading, super.exception});
}

class HomeStateNoHomes extends HomeState {
  const HomeStateNoHomes({required super.isLoading, super.exception});
}

class HomeStateInHome extends HomeState {
  final String? invitationLink;
  const HomeStateInHome({
    required super.isLoading,
    this.invitationLink,
    super.exception,
  });
}
