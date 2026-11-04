import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PortalTabs extends StatelessWidget {
  const PortalTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.counts,
  }) : assert(counts == null || counts.length == labels.length);
  final List<String> labels;
  final List<int>? counts;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppDimens.portalPageInset,
      AppDimens.portalSpaceMd,
      AppDimens.portalPageInset,
      0,
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppDimens.portalPillRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.portalSpaceXs),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final entry in labels.indexed)
                Expanded(
                  child: Semantics(
                    selected: selected == entry.$1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: selected == entry.$1
                            ? AppColors.brand
                            : Colors.transparent,
                        foregroundColor: selected == entry.$1
                            ? AppColors.surface
                            : AppColors.brand,
                        minimumSize: const Size.fromHeight(
                          AppDimens.portalPillHeight,
                        ),
                        textStyle: const TextStyle(
                          fontSize: AppDimens.portalPillTextSize,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.portalPillRadius,
                          ),
                        ),
                      ),
                      onPressed: () => onSelected(entry.$1),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppDimens.portalSpaceSm,
                        children: [
                          Text(entry.$2),
                          if (counts case final values?)
                            Text('${values[entry.$1]}'),
                        ],
                      ),
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
