import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:home_organizer/constants/deeplink_constants.dart';
import 'package:home_organizer/core/deep_link/deep_link_exception.dart';
import 'package:home_organizer/features/invitations/ui/invitation_page.dart';

class DeepLinkHandler {
  final links = AppLinks();
  late GlobalKey<NavigatorState> _navKey;

  Future<void> init(GlobalKey<NavigatorState> navKey) async {
    _navKey = navKey;

    final initial = await links.getInitialLink();
    print("getInitialLink result link: $initial");
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Handling initial link");
        _handle(initial);
      });
    }

    links.uriLinkStream.listen((uri) => _handle(uri));
  }

  void _handle(Uri uri) {
    print("Handling link: $uri");
    final segments = uri.pathSegments;

    if (segments.length == 2 && segments[0] == invitationDeepLinkSegment) {
      final id = uri.pathSegments[1];

      if (id.isEmpty) {
        throw InvalidInvitationDeepLinkException();
      }

      _pushInvitation(id);
    } else {
      throw UnknownPathDeepLinkException();
    }
  }

  void _pushInvitation(String id) {
    _navKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => InvitationPage(invitationId: id)),
      (route) => false,
    );
  }
}
