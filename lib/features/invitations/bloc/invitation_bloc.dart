import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_event.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_state.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  StreamSubscription? _sub;
  InvitationBloc(InvitationsRepository invitations)
    : super(InvitationStateWaiting()) {
    on<InvitationEventReceive>((event, emit) async {
      try {
        final invitation = await invitations.get(event.invitationId);
        emit(InvitationStateReceived(isLoading: false, invitation: invitation));
      } on Exception catch (e) {
        emit(InvitationStateReceived(isLoading: false, exception: e));
      }
    });

    on<InvitationEventAnswer>((event, emit) async {
      if (event.accept) {
        final invitation = state.invitation;
        try {
          emit(
            InvitationStateReceived(
              isLoading: true,
              invitation: invitation,
              loadingText: 'Sending response...',
            ),
          );
          await invitations.accept(invitation!);

          _sub?.cancel();
          _sub = invitations.observeStatus(invitation.id).listen((status) {
            add(_InvitationEventStatusReceived(status: status));
          });

          await Future.delayed(Duration(seconds: 20));
          if (_sub != null) {
            _sub?.cancel();
            _sub = null;
            emit(
              InvitationStateRejected(
                isLoading: false,
                exception: InvitationAcceptTimeoutException(),
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            InvitationStateReceived(
              isLoading: false,
              invitation: invitation,
              exception: e,
            ),
          );
        }
      } else {
        emit(InvitationStateRejected(isLoading: false));
      }
    });

    on<_InvitationEventStatusReceived>((event, emit) {
      final status = event.status;
      switch (status) {
        case InvitationsCollectionNames.pendingStatus:
          emit(
            InvitationStateReceived(
              isLoading: true,
              loadingText: 'Joining home status: pending',
              invitation: state.invitation,
            ),
          );
          break;
        case InvitationsCollectionNames.acceptedStatus:
          _sub?.cancel();
          _sub = null;
          emit(InvitationStateAccepted(isLoading: false));
          break;
        case InvitationsCollectionNames.failedStatus:
          _sub?.cancel();
          _sub = null;
          emit(
            InvitationStateRejected(
              isLoading: false,
              exception: InvitationAcceptFailException(),
            ),
          );
          break;
        default:
          emit(
            InvitationStateReceived(
              isLoading: true,
              loadingText: 'Joining home...',
              invitation: state.invitation,
            ),
          );
      }
    });

    on<InvitationEventDone>((event, emit) {
      emit(InvitationStateWaiting());
    });
  }
}

class _InvitationEventStatusReceived extends InvitationEvent {
  final String status;

  const _InvitationEventStatusReceived({required this.status});
}

class InvitationAcceptFailException implements Exception {}

class InvitationAcceptTimeoutException implements Exception {}
