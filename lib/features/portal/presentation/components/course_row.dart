import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../domain/model/curriculum_course.dart';
import 'course_state_chip.dart';
import 'portal_labels.dart';

class CourseRow extends StatefulWidget {
  const CourseRow({
    super.key,
    required this.course,
    required this.details,
    required this.onDetails,
    required this.onSyllabus,
  });

  final CurriculumCourse course;
  final Widget details;
  final VoidCallback onDetails;
  final VoidCallback? onSyllabus;

  @override
  State<CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow> {
  var _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) widget.onDetails();
  }

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );
  static const _separator = '\u2022';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final course = widget.course;
    final onSyllabus = widget.onSyllabus;
    final tag = course.state.tag(strings);
    final score = course.score10;
    final letter = course.letterGrade;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
        child: InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: AppDimens.portalSpaceSm,
                        children: [
                          Text(course.courseCode, style: _meta),
                          const Text(_separator, style: _meta),
                          Text(
                            strings.creditsLong(formatDecimal(course.credits)),
                            style: _meta,
                          ),
                          if (course.isElective) ...[
                            const Text(_separator, style: _meta),
                            Text(strings.elective, style: _meta),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimens.portalSpaceSm),
                    CourseStateChip(label: tag.label, color: tag.color),
                  ],
                ),
                const SizedBox(height: AppDimens.portalSpaceSm),
                Text(
                  course.courseName,
                  style: const TextStyle(
                    fontSize: AppDimens.portalCourseNameSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brand,
                  ),
                ),
                if (score != null && letter != null) ...[
                  const SizedBox(height: AppDimens.portalSpaceXs),
                  Text(
                    strings.scoreWithLetter(formatDecimal(score), letter),
                    style: const TextStyle(
                      fontSize: AppDimens.portalMetaSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
                AnimatedSize(
                  duration: AppDimens.feedbackDuration,
                  alignment: Alignment.topCenter,
                  child: _expanded ? widget.details : const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimens.portalSpaceSm),
                Row(
                  children: [
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.brand,
                    ),
                    const Spacer(),
                    onSyllabus != null
                        ? OutlinedButton(
                            onPressed: onSyllabus,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.brand,
                              side: const BorderSide(
                                color: AppColors.brand,
                                width: AppDimens.portalOutlineWidth,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.portalButtonRadius,
                                ),
                              ),
                            ),
                            child: Text(strings.syllabusShort),
                          )
                        : Flexible(
                            child: Text(
                              strings.portalNoIssuedSyllabus,
                              textAlign: TextAlign.end,
                              style: _meta.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
