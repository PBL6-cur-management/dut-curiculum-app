import 'package:flutter/material.dart';

import '../../../../common/theme/app_dimens.dart';

class PortalBadge extends StatelessWidget {
  const PortalBadge({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: AppDimens.portalBadgeAlpha),
      borderRadius: BorderRadius.circular(AppDimens.portalPillRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.portalSpaceSm,
        vertical: AppDimens.portalSpaceXs,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    ),
  );
}
