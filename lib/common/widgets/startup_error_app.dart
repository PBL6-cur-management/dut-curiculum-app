import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import 'app_page.dart';
import 'error_panel.dart';

class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('vi'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: buildAppTheme(),
    home: AppPage(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.screenPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimens.contentMaxWidth,
              ),
              child: ErrorPanel(message: message),
            ),
          ),
        ),
      ),
    ),
  );
}
