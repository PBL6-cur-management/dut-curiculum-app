import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalDisclosure extends StatelessWidget {
  const PortalDisclosure({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppDimens.portalSpaceMd),
    child: Material(
      color: AppColors.pageBackground,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.portalSpaceLg,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppDimens.portalSpaceLg,
          0,
          AppDimens.portalSpaceLg,
          AppDimens.portalSpaceLg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.brand,
        collapsedIconColor: AppColors.brand,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: AppDimens.portalPanelTitleSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        children: children,
      ),
    ),
  );
}
