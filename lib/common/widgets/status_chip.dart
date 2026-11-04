import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(
      color == AppColors.statePassed
          ? Icons.check_circle_outline
          : color == AppColors.stateFailed
          ? Icons.cancel_outlined
          : color == AppColors.stateWarning
          ? Icons.warning_amber_outlined
          : Icons.info_outline,
      size: AppDimens.sectionSize,
      color: color,
    ),
    label: Text(label, style: TextStyle(color: color)),
    backgroundColor: color.withValues(alpha: AppDimens.tintAlpha),
    side: BorderSide.none,
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
