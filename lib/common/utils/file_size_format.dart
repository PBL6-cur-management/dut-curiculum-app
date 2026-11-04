import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import 'decimal_format.dart';

const _bytesPerKilobyte = 1024;
const _bytesPerMegabyte = _bytesPerKilobyte * _bytesPerKilobyte;
const _fractionDigits = 1;

String formatFileSize(int bytes, AppLocalizations strings) {
  if (bytes < _bytesPerKilobyte) {
    return strings.bytes(bytes.toString());
  }
  if (bytes < _bytesPerMegabyte) {
    return strings.kilobytes(
      formatDecimal(
        (bytes / _bytesPerKilobyte).toStringAsFixed(_fractionDigits),
      ),
    );
  }
  return strings.megabytes(
    formatDecimal((bytes / _bytesPerMegabyte).toStringAsFixed(_fractionDigits)),
  );
}
