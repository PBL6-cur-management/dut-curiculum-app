import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class HomeSurface extends StatelessWidget {
  const HomeSurface({
    super.key,
    required this.child,
    this.radius = AppDimens.tileRadius,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withValues(alpha: AppDimens.homeShadowAlpha),
            blurRadius: AppDimens.shadowBlur,
            offset: const Offset(0, AppDimens.shadowOffset),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? child : InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
