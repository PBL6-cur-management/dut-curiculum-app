import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class CourseFilterBar extends StatelessWidget {
  const CourseFilterBar({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  final List<({String? id, String label})> items;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.portalSpaceSm),
            child: FilterChip(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              showCheckmark: false,
              side: BorderSide.none,
              shape: const StadiumBorder(),
              backgroundColor: AppColors.portalSummarySurface,
              selectedColor: AppColors.brand,
              label: Text(
                item.label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: item.id == selectedId
                      ? AppColors.surface
                      : AppColors.brand,
                ),
              ),
              selected: item.id == selectedId,
              onSelected: (_) => onSelected(item.id),
            ),
          ),
      ],
    ),
  );
}
