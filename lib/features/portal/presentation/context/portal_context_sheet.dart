import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../domain/model/portal_program.dart';
import '../components/portal_labels.dart';
import '../components/portal_theme.dart';
import 'portal_context_cubit.dart';
import 'portal_context_state.dart';

Future<void> showPortalContextSheet(
  BuildContext context, {
  VoidCallback? onBeforeChange,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => Theme(
    data: PortalTheme.from(Theme.of(context)),
    child: BlocProvider.value(
      value: context.read<PortalContextCubit>(),
      child: PortalContextSheet(onBeforeChange: onBeforeChange),
    ),
  ),
);

class PortalContextSheet extends StatelessWidget {
  const PortalContextSheet({super.key, this.onBeforeChange});
  final VoidCallback? onBeforeChange;

  void _select(BuildContext context, bool changed, VoidCallback select) {
    Navigator.of(context).pop();
    if (changed) {
      onBeforeChange?.call();
      select();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<PortalContextCubit, PortalContextState>(
    builder: (context, state) {
      final strings = AppLocalizations.of(context);
      final cubit = context.read<PortalContextCubit>();
      final programs = state.overview?.programs ?? const <PortalProgram>[];
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(
            AppDimens.portalPageInset,
            AppDimens.portalSpaceSm,
            AppDimens.portalPageInset,
            AppDimens.portalPageInset,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.portalContext,
                    style: const TextStyle(
                      fontSize: AppDimens.portalPanelTitleSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            for (final program in programs)
              _Option(
                selected: program.programId == state.selectedProgramId,
                showCheck: programs.length > 1,
                title: program.programName,
                lines: [
                  '${program.programCode} \u00b7 ${program.enrollmentType.label(strings)}',
                  program.versionNumber == null
                      ? strings.noVersion
                      : strings.fieldValue(
                          strings.version,
                          program.versionNumber!,
                        ),
                  strings.fieldValue(
                    strings.decision,
                    program.decisionNumber ?? strings.noDecision,
                  ),
                ],
                onTap: state.isLoading
                    ? null
                    : () => _select(
                        context,
                        program.programId != state.selectedProgramId,
                        () => cubit.selectProgram(program.programId),
                      ),
              ),
            const SizedBox(height: AppDimens.portalSpaceSm),
            Text(
              strings.semesterView,
              style: const TextStyle(
                fontSize: AppDimens.portalSectionSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.portalSpaceSm),
            for (final semester in state.semesters)
              _Option(
                selected: semester.id == state.overview?.semester?.id,
                showCheck: true,
                title: semester.code,
                lines: [
                  '${strings.semesterNumber(semester.termInYear)} \u00b7 ${semester.academicYear}',
                ],
                onTap: state.isLoading
                    ? null
                    : () => _select(
                        context,
                        semester.id != state.overview?.semester?.id,
                        () {
                          cubit.selectSemester(semester.id);
                        },
                      ),
              ),
          ],
        ),
      );
    },
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.selected,
    required this.showCheck,
    required this.title,
    required this.lines,
    required this.onTap,
  });

  final bool selected;
  final bool showCheck;
  final String title;
  final List<String> lines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceSm),
    child: Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.portalSummarySurface
            : AppColors.portalCourseSurface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.portalCardRadius),
          side: selected
              ? const BorderSide(
                  color: AppColors.brand,
                  width: AppDimens.portalOutlineWidth,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.portalSpaceLg,
              vertical: AppDimens.portalSpaceMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppDimens.portalCourseNameSize,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? AppColors.brand
                              : AppColors.textPrimary,
                        ),
                      ),
                      for (final line in lines)
                        Text(
                          line,
                          style: const TextStyle(
                            fontSize: AppDimens.portalMetaSize,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showCheck && selected)
                  const Icon(Icons.check_circle, color: AppColors.brand),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
