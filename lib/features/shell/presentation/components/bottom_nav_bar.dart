import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'home_surface.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final items = [
      (icon: Icons.home_outlined, label: strings.home),
      (icon: Icons.person_outline, label: strings.profile),
    ];
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppDimens.homeInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.homeInset),
        child: HomeSurface(
          radius: AppDimens.navRadius,
          child: SizedBox(
            height: AppDimens.navHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(items.length, (index) {
                final selected = index == currentIndex;
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: items[index].label,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () => onTap(index),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (selected)
                            const Positioned(
                              top: 0,
                              child: SizedBox(
                                width: AppDimens.navIndicatorWidth,
                                height: AppDimens.navIndicatorHeight,
                                child: ColoredBox(color: AppColors.brand),
                              ),
                            ),
                          Icon(
                            items[index].icon,
                            size: AppDimens.navIcon,
                            color: selected
                                ? AppColors.brand
                                : AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
