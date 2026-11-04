import 'package:flutter/material.dart';

import '../../../../common/theme/app_dimens.dart';

class SyllabusHeader extends StatelessWidget {
  const SyllabusHeader({super.key, required this.name, required this.details});
  final String name;
  final List<String> details;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceLg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: AppDimens.portalSpaceMd,
          runSpacing: AppDimens.portalSpaceXs,
          children: [
            for (final detail in details)
              Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    ),
  );
}
