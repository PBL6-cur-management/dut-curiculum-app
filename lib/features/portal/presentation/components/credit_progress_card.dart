import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import 'portal_stat_row.dart';

class CreditProgressCard extends StatelessWidget {
  const CreditProgressCard({
    super.key,
    required this.fraction,
    required this.required,
    required this.recognized,
    required this.missing,
    required this.compulsory,
    required this.elective,
    required this.free,
  });
  final double fraction;
  final String required;
  final String recognized;
  final String missing;
  final String compulsory;
  final String elective;
  final String free;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final hasRequirement = double.tryParse(required) != 0;
    final capped = fraction.clamp(0.0, 1.0).toDouble();
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
              strings.recognizedCredits,
              style: const TextStyle(
                fontSize: AppDimens.portalMetaSize,
                color: AppColors.textSecondary,
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: AppDimens.portalSpaceSm,
              children: [
                Text(
                  formatDecimal(recognized),
                  style: const TextStyle(
                    fontSize: AppDimens.portalKpiSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                if (hasRequirement)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimens.portalSpaceXs,
                    ),
                    child: Text(
                      strings.creditsOutOf(formatDecimal(required)),
                      style: const TextStyle(
                        fontSize: AppDimens.portalCourseNameSize,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.portalSpaceMd),
            if (!hasRequirement)
              Text(strings.portalNotApplicable)
            else
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimens.portalProgressHeight,
                      ),
                      child: LinearProgressIndicator(
                        value: capped,
                        minHeight: AppDimens.portalProgressHeight,
                        color: AppColors.brand,
                        backgroundColor: AppColors.surface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.portalSpaceMd),
                  Text(
                    strings.percentValue((capped * 100).toStringAsFixed(0)),
                    style: const TextStyle(
                      fontSize: AppDimens.portalCourseNameSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brand,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: AppDimens.portalSpaceLg),
            PortalStatRow(
              stats: [
                (
                  label: strings.compulsoryShort,
                  value: formatDecimal(compulsory),
                ),
                (label: strings.elective, value: formatDecimal(elective)),
                (label: strings.freeShort, value: formatDecimal(free)),
                (label: strings.missingShort, value: formatDecimal(missing)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
