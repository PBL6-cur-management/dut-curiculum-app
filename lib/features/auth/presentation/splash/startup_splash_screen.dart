import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../components/ddut_wordmark.dart';
import '../components/login_background.dart';

class StartupSplashScreen extends StatelessWidget {
  const StartupSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: LoginBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DdutWordmark(),
                  const SizedBox(height: AppDimens.largeGap),
                  const SizedBox.square(
                    dimension: AppDimens.splashIndicatorSize,
                    child: CircularProgressIndicator(
                      color: AppColors.surface,
                      strokeWidth: AppDimens.focusBorder,
                    ),
                  ),
                  const SizedBox(height: AppDimens.gap),
                  Text(
                    strings.checkingSession,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.surface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
