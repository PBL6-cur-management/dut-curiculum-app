import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'package:dut_curriculum_app/l10n/app_localizations.dart';

@module
abstract class LocalizationModule {
  @singleton
  AppLocalizations get localizations =>
      lookupAppLocalizations(const Locale('vi'));
}
