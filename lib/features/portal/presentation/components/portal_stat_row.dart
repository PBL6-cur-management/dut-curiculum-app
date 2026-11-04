import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

typedef PortalStat = ({String label, String value});

class PortalStatRow extends StatelessWidget {
  const PortalStatRow({super.key, required this.stats});
  final List<PortalStat> stats;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final stat in stats)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.label,
                style: const TextStyle(
                  fontSize: AppDimens.portalMetaSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.portalSpaceXs),
              Text(
                stat.value,
                style: const TextStyle(
                  fontSize: AppDimens.portalCourseNameSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
