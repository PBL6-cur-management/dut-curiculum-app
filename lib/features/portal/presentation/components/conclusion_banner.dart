import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class ConclusionBanner extends StatelessWidget {
  const ConclusionBanner({
    super.key,
    required this.label,
    required this.color,
    required this.lines,
  });
  final String label;
  final Color color;
  final List<String> lines;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.portalSummarySurface,
      borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: color,
                size: AppDimens.portalStateIconSize,
              ),
              const SizedBox(width: AppDimens.portalSpaceMd),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppDimens.portalScoreSize,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.portalSpaceMd),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: AppDimens.portalMetaSize,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
