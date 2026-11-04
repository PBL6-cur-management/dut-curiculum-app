import 'package:flutter/material.dart';

import 'portal_state_panel.dart';

class NoContextPanel extends StatelessWidget {
  const NoContextPanel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => PortalStatePanel(message: message);
}
