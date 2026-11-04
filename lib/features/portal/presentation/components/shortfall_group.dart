import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'portal_section_header.dart';

class ShortfallGroup extends StatelessWidget {
  const ShortfallGroup({super.key, required this.title, required this.items});
  final String title;
  final List<({String title, String message})> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PortalSectionHeader(title: title),
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, item) in items.indexed) ...[
                if (index == 0 || items[index - 1].title != item.title) ...[
                  if (index > 0)
                    const SizedBox(height: AppDimens.portalSpaceMd),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: AppDimens.portalCourseNameSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brand,
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.portalSpaceXs),
                  child: Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: AppDimens.portalMetaSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}
