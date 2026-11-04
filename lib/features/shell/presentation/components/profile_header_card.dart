import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'initials_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.fullName,
    required this.subtitle,
    required this.onBellTap,
  });

  final String fullName;
  final String subtitle;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.brand,
    borderRadius: BorderRadius.circular(AppDimens.tileRadius),
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.homeHeaderPadding),
      child: Row(
        children: [
          InitialsAvatar(fullName: fullName),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimens.homeNameSize,
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
                    fontSize: AppDimens.homeEmailSize,
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).notifications,
            onPressed: onBellTap,
            icon: const Icon(
              Icons.notifications,
              size: AppDimens.homeBellSize,
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    ),
  );
}
