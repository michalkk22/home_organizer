import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:home_organizer/constants/deeplink_constants.dart';
import 'package:home_organizer/core/deep_link/deep_link_exception.dart';
import 'package:home_organizer/features/auth/ui/auth_page.dart';

class DeepLinkHandler {
  final links = AppLinks();
  late BuildContext _context;

  Future<void> init(BuildContext context) async {
    _context = context;

    final initial = await links.getInitialLink();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handle(initial);
      });
    }

    links.uriLinkStream.listen((uri) => _handle(uri));
  }

  void _handle(Uri uri) {
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
    Navigator.of(_context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AuthPage()),
      (route) => false,
    );
  }
}
