import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'app_card.dart';

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      children: [
        const Icon(Icons.inbox_outlined, color: AppColors.textSecondary),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
