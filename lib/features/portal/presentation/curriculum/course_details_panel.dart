import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../domain/model/course_state.dart';
import '../../domain/model/curriculum_course.dart';
import '../components/portal_stat_row.dart';
import 'curriculum_cubit.dart';
import 'curriculum_state.dart';

class CourseDetailsPanel extends StatelessWidget {
  const CourseDetailsPanel({super.key, required this.course});
  final CurriculumCourse course;

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CurriculumCubit, CurriculumState>(
        builder: (context, state) {
          final strings = AppLocalizations.of(context);
          final source = state.equivalentCourses[course.itemId];
          String value(String? raw) =>
              raw == null ? strings.emptyValue : formatDecimal(raw);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(height: AppDimens.portalSpaceLg * 2),
              PortalStatRow(
                stats: [
                  (label: strings.scoreTenLabel, value: value(course.score10)),
                  (label: strings.scoreFourLabel, value: value(course.score4)),
                  (
                    label: strings.letterGradeLabel,
                    value: course.letterGrade ?? strings.emptyValue,
                  ),
                  (
                    label: strings.attemptCountLabel,
                    value: '${course.attemptCount}',
                  ),
                ],
              ),
              if (course.state == CourseState.passedEquivalent) ...[
                const SizedBox(height: AppDimens.portalSpaceMd),
                if (state.isLoadingEquivalent)
                  const LinearProgressIndicator()
                else if (state.equivalentError != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          strings.portalEquivalentUnavailable,
                          style: _meta,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context
                            .read<CurriculumCubit>()
                            .loadEquivalentCourses(force: true),
                        child: Text(strings.retry),
                      ),
                    ],
                  )
                else if (source != null)
                  Text(
                    strings.portalEquivalentFrom(
                      '${source.code} \u00b7 ${source.name}',
                    ),
                    style: _meta,
                  )
                else if (state.equivalentLoaded)
                  Text(strings.portalEquivalentNotSupplied, style: _meta),
              ],
            ],
          );
        },
      );
}
