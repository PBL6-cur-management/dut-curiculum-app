import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class DdutWordmark extends StatelessWidget {
  const DdutWordmark({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).wordmark,
    child: ExcludeSemantics(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: AppDimens.wordmarkSize,
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimens.logoLetterSpacing,
              color: AppColors.surface,
            ),
            children: [
              TextSpan(text: AppLocalizations.of(context).wordmarkPrefix),
              TextSpan(
                text: AppLocalizations.of(context).wordmarkU,
                style: const TextStyle(color: AppColors.wordmarkYellow),
              ),
              TextSpan(
                text: AppLocalizations.of(context).wordmarkT,
                style: const TextStyle(color: AppColors.wordmarkRed),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
