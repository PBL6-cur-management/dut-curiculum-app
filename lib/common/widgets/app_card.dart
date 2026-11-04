import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_component_theme.dart';
import '../theme/app_dimens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.padding = const EdgeInsets.all(AppDimens.pagePadding),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!AppComponentTheme.usesLegacySheetStyle(context)) {
      return Material(
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          side: BorderSide(
            color: AppColors.textSecondary.withValues(
              alpha: AppDimens.borderAlpha,
            ),
            width: AppDimens.hairline,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding == const EdgeInsets.all(AppDimens.pagePadding)
              ? const EdgeInsets.all(AppDimens.spaceLg)
              : padding,
          child: child,
        ),
      );
    }
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.loginCardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(
              alpha: AppDimens.shadowAlpha,
            ),
            blurRadius: AppDimens.shadowBlur,
            offset: const Offset(0, AppDimens.shadowOffset),
          ),
        ],
      ),
      child: child,
    );
  }
}
