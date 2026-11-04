import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class TermSection extends StatelessWidget {
  const TermSection({
    super.key,
    required this.title,
    required this.credits,
    required this.initiallyExpanded,
    required this.children,
  });

  final String title;
  final String credits;
  final bool initiallyExpanded;
  final List<Widget> children;

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
          AppDimens.portalSpaceMd,
          0,
          AppDimens.portalSpaceMd,
          AppDimens.portalSpaceXs,
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.brand,
        collapsedIconColor: AppColors.brand,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: AppDimens.portalTermTitleSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          credits,
          style: const TextStyle(
            fontSize: AppDimens.portalMetaSize,
            color: AppColors.textSecondary,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        children: children,
      ),
    ),
  );
}
