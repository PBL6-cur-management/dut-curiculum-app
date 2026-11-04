import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';

class CreditSummaryPanel extends StatelessWidget {
  const CreditSummaryPanel({
    super.key,
    required this.earned,
    required this.total,
  });

  final double earned;
  final String total;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final required = double.tryParse(total) ?? 0;
    final fraction = required == 0 ? 0.0 : (earned / required).clamp(0.0, 1.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.portalSummarySurface,
        borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.earnedCreditsOf(
                formatCredits(earned),
                formatDecimal(total),
              ),
              style: const TextStyle(
                fontSize: AppDimens.portalPanelTitleSize,
                fontWeight: FontWeight.w700,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: AppDimens.portalSpaceMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.portalPillRadius),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: AppDimens.portalSpaceSm,
                color: AppColors.brand,
                backgroundColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: AppDimens.portalSpaceSm),
            Text(
              strings.fieldValue(strings.requiredCredits, formatDecimal(total)),
              style: const TextStyle(
                fontSize: AppDimens.portalMetaSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
