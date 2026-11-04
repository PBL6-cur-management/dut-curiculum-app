import 'package:flutter/material.dart';

import '../theme/app_component_theme.dart';
import '../theme/app_dimens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: !AppComponentTheme.usesLegacySheetStyle(context)
        ? const EdgeInsets.only(
            top: AppDimens.spaceSm,
            bottom: AppDimens.spaceSm,
          )
        : const EdgeInsets.symmetric(vertical: AppDimens.gap),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
