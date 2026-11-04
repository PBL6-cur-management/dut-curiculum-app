import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../domain/model/course_state.dart';
import '../../domain/model/curriculum_course.dart';
import '../components/course_filter_bar.dart';
import '../components/course_row.dart';
import '../components/credit_summary_panel.dart';
import '../components/portal_labels.dart';
import '../components/portal_page.dart';
import '../components/portal_pill_link.dart';
import '../components/portal_section_header.dart';
import '../components/portal_state_panel.dart';
import '../components/term_section.dart';
import '../context/portal_context_cubit.dart';
import 'course_details_panel.dart';
import 'curriculum_cubit.dart';
import 'curriculum_state.dart';

class CurriculumScreen extends StatelessWidget {
  const CurriculumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.myCurriculum,
      body: BlocBuilder<CurriculumCubit, CurriculumState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          if (state.errorMessage case final message?) {
            return PortalStatePanel(
              message: message,
              isError: true,
              onRetry: context.read<CurriculumCubit>().load,
            );
          }
          final data = state.data;
          if (data == null) return PortalStatePanel(message: strings.noData);
          return ListView(
            padding: const EdgeInsets.all(AppDimens.portalPageInset),
            children: [
              _shortcuts(context, strings),
              const SizedBox(height: AppDimens.portalSpaceLg),
              CreditSummaryPanel(
                earned: state.earnedCredits,
                total: data.totalCredits,
              ),
              const SizedBox(height: AppDimens.portalSpaceMd),
              CourseFilterBar(
                items: [
                  (
                    id: null,
                    label: strings.labelWithCount(
                      strings.allCourses,
                      state.countFor(null),
                    ),
                  ),
                  for (final value in CourseState.values)
                    if (value != CourseState.passedEquivalent)
                      (
                        id: value.name,
                        label: strings.labelWithCount(
                          value.tag(strings).label,
                          state.countFor(value),
                        ),
                      ),
                ],
                selectedId: state.filter?.name,
                onSelected: (id) => context.read<CurriculumCubit>().setFilter(
                  id == null ? null : CourseState.values.byName(id),
                ),
              ),
              if (data.terms.isEmpty)
                PortalStatePanel(message: strings.portalNoTerms)
              else if (state.terms.isEmpty) ...[
                PortalStatePanel(message: strings.portalNoFilterMatches),
                TextButton(
                  onPressed: () =>
                      context.read<CurriculumCubit>().setFilter(null),
                  child: Text(strings.portalClearFilter),
                ),
              ],
              for (final term in state.terms)
                TermSection(
                  key: PageStorageKey((
                    context.read<PortalContextCubit>().state.context,
                    term.plannedSemester,
                    state.filter,
                  )),
                  title: strings.semesterNumber(term.plannedSemester),
                  credits: strings.portalCompulsoryCredits(
                    formatDecimal(term.credits),
                  ),
                  initiallyExpanded: state.expandedTerms.contains(
                    term.plannedSemester,
                  ),
                  children: [
                    for (final course in term.courses.where(
                      (course) => !course.isElective,
                    ))
                      _course(context, course),
                    for (final course in term.courses.where(
                      (course) =>
                          course.isElective &&
                          (course.groupName == null ||
                              course.groupName!.trim().isEmpty),
                    ))
                      _course(context, course),
                    for (final group
                        in term.courses
                            .where((course) => course.isElective)
                            .map((course) => course.groupName)
                            .whereType<String>()
                            .where((group) => group.trim().isNotEmpty)
                            .toSet()) ...[
                      PortalSectionHeader(title: group),
                      Text(strings.portalChooseWithinGroup),
                      for (final course in term.courses.where(
                        (course) =>
                            course.isElective && course.groupName == group,
                      ))
                        _course(context, course),
                    ],
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _shortcuts(BuildContext context, AppLocalizations strings) {
    final links = [
      (
        icon: Icons.flag_outlined,
        label: strings.shortcutPlo,
        path: RoutePaths.plos,
      ),
      (
        icon: Icons.bar_chart_outlined,
        label: strings.shortcutProgress,
        path: RoutePaths.progress,
      ),
      (
        icon: Icons.checklist_outlined,
        label: strings.shortcutEligibility,
        path: RoutePaths.registration,
      ),
      (
        icon: Icons.verified_outlined,
        label: strings.shortcutGraduation,
        path: RoutePaths.graduation,
      ),
    ];
    Widget pill(int i) => Expanded(
      child: PortalPillLink(
        icon: links[i].icon,
        label: links[i].label,
        onTap: () {
          context.push(links[i].path);
        },
      ),
    );
    return Column(
      children: [
        for (var row = 0; row < links.length; row += 2) ...[
          if (row > 0) const SizedBox(height: AppDimens.portalSpaceSm),
          Row(
            children: [
              pill(row),
              const SizedBox(width: AppDimens.portalSpaceSm),
              pill(row + 1),
            ],
          ),
        ],
      ],
    );
  }

  Widget _course(BuildContext context, CurriculumCourse course) => CourseRow(
    key: ValueKey(course.itemId),
    course: course,
    details: CourseDetailsPanel(course: course),
    onDetails: () {
      if (course.state == CourseState.passedEquivalent)
        context.read<CurriculumCubit>().loadEquivalentCourses();
    },
    onSyllabus: course.hasSyllabus
        ? () {
            context.push(RoutePaths.syllabusFor(course.itemId));
          }
        : null,
  );
}
