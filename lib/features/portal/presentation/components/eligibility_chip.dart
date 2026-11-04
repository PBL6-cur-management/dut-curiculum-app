import 'package:flutter/material.dart';

import 'portal_badge.dart';

class EligibilityChip extends StatelessWidget {
  const EligibilityChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => PortalBadge(label: label, color: color);
}
