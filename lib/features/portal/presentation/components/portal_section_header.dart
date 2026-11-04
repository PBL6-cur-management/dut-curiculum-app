import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalSectionHeader extends StatelessWidget {
  const PortalSectionHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppDimens.portalSpaceLg,
      bottom: AppDimens.portalSpaceMd,
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: AppDimens.portalTermTitleSize,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
