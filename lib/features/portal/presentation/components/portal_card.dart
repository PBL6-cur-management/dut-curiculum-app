import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalCard extends StatelessWidget {
  const PortalCard({
    super.key,
    required this.child,
    this.color = AppColors.portalCourseSurface,
    this.elevation = AppDimens.portalFlatElevation,
  });
  final Widget child;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
    child: Material(
      color: color,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppDimens.portalCardRadius),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
        child: child,
      ),
    ),
  );
}
