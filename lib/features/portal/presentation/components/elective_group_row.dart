import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import 'portal_card.dart';

class ElectiveGroupRow extends StatelessWidget {
  const ElectiveGroupRow({
    super.key,
    required this.title,
    required this.requiredCredits,
    required this.earnedCredits,
    required this.missingCredits,
    required this.requiredCourses,
    required this.earnedCourses,
    required this.missingCourses,
  });
  final String title;
  final String? requiredCredits;
  final String earnedCredits;
  final String? missingCredits;
  final int? requiredCourses;
  final int earnedCourses;
  final int? missingCourses;

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalCard(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimens.portalCourseNameSize,
              fontWeight: FontWeight.w500,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(height: AppDimens.portalSpaceXs),
          Text(
            strings.requiredEarnedMissing(
              requiredCredits == null
                  ? strings.notSpecified
                  : formatDecimal(requiredCredits!),
              formatDecimal(earnedCredits),
              missingCredits == null
                  ? strings.notSpecified
                  : formatDecimal(missingCredits!),
            ),
            style: _meta,
          ),
          Text(
            strings.courseCount(
              requiredCourses?.toString() ?? strings.notSpecified,
              earnedCourses.toString(),
              missingCourses?.toString() ?? strings.notSpecified,
            ),
            style: _meta,
          ),
        ],
      ),
    );
  }
}
