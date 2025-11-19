import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_event.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_state.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc(InvitationsRepository invitations)
    : super(InvitationStateWaiting()) {
    on<InvitationEventReceive>((event, emit) async {
      try {
        emit(InvitationStateReceived(isLoading: true));
        final invitation = await invitations.get(event.invitationId);
        emit(InvitationStateReceived(isLoading: false, invitation: invitation));
      } on Exception catch (e) {
        emit(InvitationStateReceived(isLoading: false, exception: e));
      }
    });

    on<InvitationEventAnswer>((event, emit) async {
      if (event.accept) {
        final received = state as InvitationStateReceived;
        try {
          emit(
            InvitationStateReceived(
              isLoading: true,
              invitation: received.invitation,
            ),
          );
          await invitations.accept(received.invitation!.id);
          emit(InvitationStateAccepted());
        } on Exception catch (e) {
          emit(
            InvitationStateReceived(
              isLoading: false,
              invitation: received.invitation,
              exception: e,
            ),
          );
        }
      } else {
        emit(InvitationStateRejected());
      }
    });

    on<InvitationEventDone>((event, emit) {
      emit(InvitationStateWaiting());
    });
  }
}
