import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalPillLink extends StatelessWidget {
  const PortalPillLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.portalSummarySurface,
    shape: const StadiumBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: AppDimens.portalPillHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.portalSpaceLg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimens.portalPillIconSize,
                color: AppColors.brand,
              ),
              const SizedBox(width: AppDimens.portalSpaceSm),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimens.portalPillTextSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brand,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
