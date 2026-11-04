import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.fullName,
    required this.subtitle,
  });

  final String fullName;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.brand,
    borderRadius: BorderRadius.circular(AppDimens.tileRadius),
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.homeHeaderPadding),
      child: Row(
        children: [
          Container(
            width: AppDimens.profilePhotoSize,
            height: AppDimens.profilePhotoSize,
            decoration: BoxDecoration(
              color: AppColors.pageBackground,
              borderRadius: BorderRadius.circular(AppDimens.profilePhotoRadius),
              border: Border.all(
                color: AppColors.surface,
                width: AppDimens.profilePhotoBorder,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: AppDimens.profilePhotoIcon,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimens.profileNameSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimens.profileEmailSize,
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
