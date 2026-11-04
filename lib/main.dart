import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import 'app.dart';
import 'common/widgets/startup_error_app.dart';
import 'core/di/getit_utils.dart';
import 'core/network/api_config.dart';
import 'features/auth/presentation/session/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final strings = lookupAppLocalizations(const Locale('vi'));
  // Throwing here, before any runApp, leaves the device frozen on the native
  // launch screen with the reason visible only in logcat.
  if (ApiConfig.baseUrl.isEmpty) {
    runApp(StartupErrorApp(message: strings.missingApiBaseUrl));
    return;
  }
  try {
    await configureDependencies();
    runApp(App(session: getIt<SessionCubit>()));
  } catch (error) {
    runApp(StartupErrorApp(message: error.toString()));
  }
}
