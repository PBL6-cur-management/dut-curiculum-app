import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';

class FieldValueRow extends StatelessWidget {
  const FieldValueRow({
    super.key,
    required this.label,
    required this.value,
    this.selectable = false,
  });

  final String label;
  final String value;
  final bool selectable;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: AppDimens.labelFlex,
              child: Text(label, style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              flex: AppDimens.valueFlex,
              child: selectable
                  ? SelectableText(value, textAlign: TextAlign.end)
                  : Text(
                      value,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
            ),
          ],
        ),
      ),
      const Divider(),
    ],
  );
}
