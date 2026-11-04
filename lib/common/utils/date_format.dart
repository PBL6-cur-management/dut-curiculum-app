import 'package:dut_curriculum_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String formatWeekday(int epochMs, AppLocalizations strings) {
  final weekday = DateTime.fromMillisecondsSinceEpoch(epochMs).weekday;
  return switch (weekday) {
    DateTime.monday => strings.monday,
    DateTime.tuesday => strings.tuesday,
    DateTime.wednesday => strings.wednesday,
    DateTime.thursday => strings.thursday,
    DateTime.friday => strings.friday,
    DateTime.saturday => strings.saturday,
    _ => strings.sunday,
  };
}

String formatDay(int epochMs) =>
    DateTime.fromMillisecondsSinceEpoch(epochMs).day.toString().padLeft(2, '0');

int monthOf(int epochMs) => DateTime.fromMillisecondsSinceEpoch(epochMs).month;

String formatTimestamp(int epochMs) => DateFormat(
  'dd/MM/yyyy HH:mm',
  'vi',
).format(DateTime.fromMillisecondsSinceEpoch(epochMs));
