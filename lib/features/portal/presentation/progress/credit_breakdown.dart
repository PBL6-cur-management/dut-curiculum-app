import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../domain/model/graduation_result.dart';
import '../components/elective_group_row.dart';
import '../components/knowledge_block_row.dart';

class CreditBreakdown extends StatelessWidget {
  const CreditBreakdown({super.key, required this.result});
  final GraduationResult result;

  static Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(
      top: AppDimens.portalSpaceSm,
      bottom: AppDimens.portalSpaceSm,
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: AppDimens.portalMetaSize,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final blocks = [
      for (final block in result.knowledgeBlocks)
        if (block.blockName != null || block.blockSymbol != null) block,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (result.electiveGroups.isNotEmpty) _heading(strings.electiveGroups),
        for (final group in result.electiveGroups)
          ElectiveGroupRow(
            title: strings.fieldValue(group.groupCode, group.groupName),
            requiredCredits: group.requiredCredits,
            earnedCredits: group.earnedCredits,
            missingCredits: group.missingCredits,
            requiredCourses: group.requiredCourses,
            earnedCourses: group.earnedCourses,
            missingCourses: group.missingCourses,
          ),
        if (blocks.isNotEmpty) _heading(strings.knowledgeBlocks),
        for (final (index, block) in blocks.indexed) ...[
          if (index > 0) const Divider(height: AppDimens.portalDividerWidth),
          KnowledgeBlockRow(
            title: block.blockName ?? block.blockSymbol!,
            earned: block.earnedCredits,
            compulsory: block.compulsoryCredits,
            elective: block.electiveCredits,
            requiredCredits: block.catalogRequiredCredits,
            gap: block.advisoryGap,
          ),
        ],
      ],
    );
  }
}
