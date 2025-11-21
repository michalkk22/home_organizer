import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home_organizer/features/auth/bloc/auth_bloc.dart';
import 'package:home_organizer/features/auth/bloc/auth_state.dart';
import 'package:home_organizer/features/auth/ui/auth_page.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_bloc.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_event.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_state.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';
import 'package:home_organizer/features/invitations/ui/views/invitation_view.dart';
import 'package:home_organizer/features/invitations/ui/views/must_login_view.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({super.key, required this.invitationId});
  final String invitationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invitation')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateLoggedIn) {
              final getIt = GetIt.instance;
              return BlocProvider(
                create:
                    (context) => InvitationBloc(getIt<InvitationsRepository>())
                      ..add(InvitationEventReceive(invitationId: invitationId)),
                child: BlocConsumer<InvitationBloc, InvitationState>(
                  builder: (context, state) {
                    if (state is InvitationStateReceived) {
                      return InvitationView(
                        invitation: state.invitation,
                        exception: state.exception,
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  listener: (
                    BuildContext context,
                    InvitationState state,
                  ) async {
                    if (state is InvitationStateReceived) {
                      if (state.isLoading) {
                        LoadingScreen().show(context: context);
                      } else {
                        LoadingScreen().hide();
                      }
                    } else if (state is InvitationStateAccepted) {
                      final savedContext = context;
                      await showDialog(
                        context: savedContext,
                        builder:
                            (_) => AlertDialog(
                              title: Text('Success'),
                              content: Text('You accepted the invitation.'),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(savedContext).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                      );
                      Navigator.of(savedContext).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => AuthPage()),
                        (route) => false,
                      );
                    } else if (state is InvitationStateRejected) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => AuthPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              );
            } else {
              return MustLoginView();
            }
          },
        ),
      ),
    );
  }
}
