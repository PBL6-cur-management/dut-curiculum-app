import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../theme/app_colors.dart';
import '../theme/app_component_theme.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (AppComponentTheme.usesLegacySheetStyle(context)) {
      return AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.stateFailed),
            const SizedBox(height: AppDimens.gap),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context).retry),
              ),
          ],
        ),
      );
    }
    return Theme(
      data: buildComponentTheme(Theme.of(context)),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, color: AppColors.stateFailed),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(child: Text(message)),
              ],
            ),
            if (onRetry != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: onRetry,
                  child: Text(AppLocalizations.of(context).retry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
