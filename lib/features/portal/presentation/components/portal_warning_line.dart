import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalWarningLine extends StatelessWidget {
  const PortalWarningLine({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppDimens.portalSpaceSm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: AppDimens.portalBadgeIconSize,
          color: AppColors.stateWarning,
        ),
        const SizedBox(width: AppDimens.portalSpaceSm),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: AppDimens.portalMetaSize,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
