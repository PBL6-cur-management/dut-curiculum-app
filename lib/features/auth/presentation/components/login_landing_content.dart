import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'ddut_wordmark.dart';

class LoginLandingContent extends StatelessWidget {
  const LoginLandingContent({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.pagePadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - AppDimens.pagePadding * 2,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimens.contentMaxWidth,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DdutWordmark(),
                    const SizedBox(height: AppDimens.loginTitleGap),
                    Text(
                      strings.loginWelcome,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppDimens.largeGap),
                    Text(
                      strings.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.surface),
                    ),
                    const SizedBox(height: AppDimens.largeGap),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.loginGradientCenter,
                        ),
                        onPressed: onLogin,
                        child: Text(strings.loginButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
