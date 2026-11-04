import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalStatePanel extends StatelessWidget {
  const PortalStatePanel({
    super.key,
    required this.message,
    this.onRetry,
    this.isError = false,
  });
  final String message;
  final VoidCallback? onRetry;
  final bool isError;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimens.portalPageInset),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.portalSummarySurface,
        borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.portalSpaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              size: AppDimens.portalStateIconSize,
              color: isError ? AppColors.stateFailed : AppColors.brand,
            ),
            const SizedBox(height: AppDimens.portalSpaceMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppDimens.portalCourseNameSize,
                color: AppColors.textPrimary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.portalSpaceMd),
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brand,
                  side: const BorderSide(
                    color: AppColors.brand,
                    width: AppDimens.portalOutlineWidth,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.portalButtonRadius,
                    ),
                  ),
                ),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
