import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../domain/model/home_tile.dart';

extension HomeTilePresentation on HomeTile {
  String label(AppLocalizations strings) => switch (this) {
    HomeTile.curriculum => strings.curriculum,
    HomeTile.timetable => strings.timetable,
    HomeTile.academicResults => strings.academicResults,
    HomeTile.academicAffairs => strings.academicAffairs,
    HomeTile.homeroomClass => strings.homeroomClass,
    HomeTile.tuition => strings.tuition,
    HomeTile.creditRegistration => strings.creditRegistration,
    HomeTile.communityActivities => strings.communityActivities,
    HomeTile.assistant => strings.assistant,
    HomeTile.feedback => strings.feedback,
    HomeTile.serviceQueue => strings.serviceQueue,
  };

  IconData get icon => switch (this) {
    HomeTile.curriculum => Icons.school_outlined,
    HomeTile.timetable => Icons.calendar_month_outlined,
    HomeTile.academicResults => Icons.track_changes,
    HomeTile.academicAffairs => Icons.show_chart,
    HomeTile.homeroomClass => Icons.people_outline,
    HomeTile.tuition => Icons.monetization_on_outlined,
    HomeTile.creditRegistration => Icons.menu_book_outlined,
    HomeTile.communityActivities => Icons.diversity_3_outlined,
    HomeTile.assistant => Icons.smart_toy_outlined,
    HomeTile.feedback => Icons.announcement_outlined,
    HomeTile.serviceQueue => Icons.confirmation_number_outlined,
  };

  String get destination => this == HomeTile.curriculum
      ? RoutePaths.curriculumProgram
      : RoutePaths.placeholderFor(name);
}
