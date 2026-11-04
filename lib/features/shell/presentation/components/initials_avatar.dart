import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    final initials = words.isEmpty
        ? ''
        : [
            words.first,
            if (words.length > 1) words.last,
          ].map((word) => word.characters.first).join().toUpperCase();
    return CircleAvatar(
      radius: AppDimens.avatarRadius + AppDimens.avatarRing,
      backgroundColor: AppColors.surface,
      child: CircleAvatar(
        radius: AppDimens.avatarRadius,
        backgroundColor: AppColors.pageBackground,
        foregroundColor: AppColors.brand,
        child: initials.isEmpty
            ? const Icon(Icons.person_outline)
            : Text(initials),
      ),
    );
  }
}
