import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/invitations/bloc/invitations_event.dart';
import 'package:home_organizer/features/invitations/bloc/invitations_state.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

class InvitationsBloc extends Bloc<InvitationsEvent, InvitationsState> {
  InvitationsBloc(InvitationsRepository _invitationsRepository)
    : super(InvitationsStateWaiting()) {
    on<InvitationsEventAnswer>((event, emit) {
      if (event.accept) {
        final recveived = state as InvitationsStateReceived;
        _invitationsRepository.accept(recveived.invitation.id);
      }
    });
  }
}
