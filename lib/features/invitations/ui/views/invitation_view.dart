import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_bloc.dart';
import 'package:home_organizer/features/invitations/bloc/invitation_event.dart';
import 'package:home_organizer/features/invitations/data/invitation.dart';

class InvitationView extends StatelessWidget {
  const InvitationView({super.key, required this.invitation, this.exception});
  final Invitation? invitation;
  final Exception? exception;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        children: [
          SizedBox(height: 20),
          Text(
            invitation?.senderName ?? 'sender',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'invited you to home:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            invitation?.homeName ?? 'home',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ElevatedButton(
            onPressed:
                exception == null
                    ? () => context.read<InvitationBloc>().add(
                      InvitationEventAnswer(accept: true),
                    )
                    : null,
            child: Text('Accept'),
          ),
          ElevatedButton(
            onPressed:
                () => context.read<InvitationBloc>().add(
                  InvitationEventAnswer(accept: false),
                ),
            child: Text('Back to login'),
          ),
        ],
      ),
    );
  }
}
