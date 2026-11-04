import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';

class KnowledgeBlockRow extends StatelessWidget {
  const KnowledgeBlockRow({
    super.key,
    required this.title,
    required this.earned,
    required this.compulsory,
    required this.elective,
    required this.requiredCredits,
    required this.gap,
  });
  final String title;
  final String earned;
  final String compulsory;
  final String elective;
  final String? requiredCredits;
  final String? gap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimens.portalSpaceSm),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: AppDimens.portalCourseNameSize,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.portalSpaceMd),
        Text(
          AppLocalizations.of(context).creditsValue(formatDecimal(earned)),
          style: const TextStyle(
            fontSize: AppDimens.portalCourseNameSize,
            fontWeight: FontWeight.w700,
            color: AppColors.brand,
          ),
        ),
      ],
    ),
  );
}
