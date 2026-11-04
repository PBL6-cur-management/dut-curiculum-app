import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'home_surface.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => HomeSurface(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppDimens.tileIcon, color: AppColors.brand),
          const SizedBox(height: AppDimens.tileLabelGap),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppDimens.featureLabel,
              fontWeight: FontWeight.w500,
              color: AppColors.brand,
              height: AppDimens.tileLabelLineHeight,
            ),
          ),
          // Balances the icon gap so the pair sits just above centre, as in dDUT.
          const SizedBox(height: AppDimens.tileLabelGap),
        ],
      ),
    ),
  );
}
