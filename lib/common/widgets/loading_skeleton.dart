import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.lines = AppDimens.skeletonLines});

  final int lines;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).loading,
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          lines,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.gap),
            child: Container(
              height: AppDimens.skeletonHeight,
              decoration: BoxDecoration(
                color: AppColors.brand.withValues(alpha: AppDimens.tintAlpha),
                borderRadius: BorderRadius.circular(AppDimens.radiusXs),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
