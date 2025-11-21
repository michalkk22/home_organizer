import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/user.dart';

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
  final User user;
  final Home home;
  final String? invitationLink;
  final Exception? exception;
  const HomeStateInHome({
    required super.isLoading,
    required this.user,
    required this.home,
    this.invitationLink,
    this.exception,
  });
}
