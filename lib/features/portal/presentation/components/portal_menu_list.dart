import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'portal_card.dart';

class PortalMenuList extends StatelessWidget {
  const PortalMenuList({super.key, required this.items});
  final List<({IconData icon, String label, String hint, VoidCallback onTap})>
  items;

  @override
  Widget build(BuildContext context) => PortalCard(
    color: AppColors.surface,
    elevation: AppDimens.portalCardElevation,
    child: Column(
      children: [
        for (final entry in items.indexed) ...[
          if (entry.$1 > 0)
            Divider(
              height: AppDimens.portalDividerWidth,
              thickness: AppDimens.portalDividerWidth,
              color: AppColors.textSecondary.withValues(
                alpha: AppDimens.portalDividerAlpha,
              ),
            ),
          ListTile(
            minTileHeight: AppDimens.portalMenuRowMinHeight,
            leading: Icon(entry.$2.icon),
            title: Text(entry.$2.label),
            subtitle: Text(entry.$2.hint),
            trailing: const Icon(Icons.chevron_right),
            onTap: entry.$2.onTap,
          ),
        ],
      ],
    ),
  );
}
