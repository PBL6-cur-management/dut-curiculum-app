import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../domain/model/academic_result.dart';
import 'course_state_chip.dart';
import 'portal_labels.dart';
import 'portal_stat_row.dart';

class ResultRow extends StatefulWidget {
  const ResultRow({super.key, required this.result});
  final AcademicResult result;

  @override
  State<ResultRow> createState() => _ResultRowState();
}

class _ResultRowState extends State<ResultRow> {
  var _expanded = false;

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );
  static const _separator = '\u2022';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final result = widget.result;
    String value(String? raw) =>
        raw == null ? strings.emptyValue : formatDecimal(raw);
    final grade =
        result.letterGrade ??
        (result.score10 != null
            ? strings.portalScore10(formatDecimal(result.score10!))
            : result.score4 != null
            ? strings.portalScore4(formatDecimal(result.score4!))
            : strings.emptyValue);
    final tag = result.status.tag(strings);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
      child: Material(
        color: AppColors.pageBackground,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppDimens.portalSpaceSm,
                          children: [
                            Text(result.course.code, style: _meta),
                            const Text(_separator, style: _meta),
                            Text(
                              strings.semesterCodeLabel(result.semester.code),
                              style: _meta,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.portalSpaceSm),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              constraints.maxWidth *
                              AppDimens.portalChipMaxWidthFraction,
                        ),
                        child: CourseStateChip(
                          label: tag.label,
                          color: tag.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.portalSpaceSm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        result.course.name,
                        style: const TextStyle(
                          fontSize: AppDimens.portalCourseNameSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brand,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.portalSpaceMd),
                    Text(
                      grade,
                      style: const TextStyle(
                        fontSize: AppDimens.portalPanelTitleSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: AppDimens.feedbackDuration,
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? Column(
                          children: [
                            const Divider(height: AppDimens.portalSpaceLg * 2),
                            PortalStatRow(
                              stats: [
                                (
                                  label: strings.scoreTenLabel,
                                  value: value(result.score10),
                                ),
                                (
                                  label: strings.scoreFourLabel,
                                  value: value(result.score4),
                                ),
                                (
                                  label: strings.letterGradeLabel,
                                  value:
                                      result.letterGrade ?? strings.emptyValue,
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.brand,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
