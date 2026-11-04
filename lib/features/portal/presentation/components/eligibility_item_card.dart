import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../domain/model/catalog_status.dart';
import '../../domain/model/eligibility.dart';
import '../../domain/model/eligibility_item.dart';
import 'eligibility_chip.dart';
import 'portal_labels.dart';
import 'portal_warning_line.dart';

class EligibilityItemCard extends StatefulWidget {
  const EligibilityItemCard({
    super.key,
    required this.item,
    this.warningMessages = const [],
  });
  final EligibilityItem item;
  final List<String> warningMessages;

  @override
  State<EligibilityItemCard> createState() => _EligibilityItemCardState();
}

class _EligibilityItemCardState extends State<EligibilityItemCard> {
  var _expanded = false;

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );
  static const _body = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textPrimary,
  );
  static const _separator = '\u2022';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final item = widget.item;
    final tag = item.eligibility?.tag(strings);
    final reasons = item.reasons.isEmpty ? [item.statusText] : item.reasons;
    final concurrent = item.requiredConcurrentCourses.isEmpty
        ? null
        : strings.mustStudyTogether(
            item.requiredConcurrentCourses
                .map((course) => '${course.code} \u00b7 ${course.name}')
                .join(', '),
          );
    final hasMore =
        reasons.length > 1 ||
        widget.warningMessages.length > 1 ||
        (concurrent != null && item.eligibility != Eligibility.conditional);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
      child: Material(
        color: AppColors.pageBackground,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
        child: InkWell(
          onTap: hasMore ? () => setState(() => _expanded = !_expanded) : null,
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
                            Text(item.course.code, style: _meta),
                            const Text(_separator, style: _meta),
                            Text(
                              strings.creditsValue(formatDecimal(item.credits)),
                              style: _meta,
                            ),
                            const Text(_separator, style: _meta),
                            Text(
                              strings.semesterNumber(item.plannedSemester),
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
                        child: EligibilityChip(
                          label: tag?.label ?? strings.portalUnknownEligibility,
                          color: tag?.color ?? AppColors.stateNeutral,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.portalSpaceSm),
                Text(
                  item.course.name,
                  style: const TextStyle(
                    fontSize: AppDimens.portalCourseNameSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brand,
                  ),
                ),
                const SizedBox(height: AppDimens.portalSpaceXs),
                Text(reasons.first, style: _body),
                if (item.eligibility == Eligibility.conditional &&
                    concurrent != null)
                  PortalWarningLine(message: concurrent),
                if (item.catalogStatus != CatalogStatus.active)
                  PortalWarningLine(
                    message: item.catalogStatus == CatalogStatus.discontinued
                        ? strings.catalogDiscontinued
                        : strings.catalogCancelled,
                  ),
                if (widget.warningMessages.isNotEmpty)
                  PortalWarningLine(message: widget.warningMessages.first),
                if (hasMore) ...[
                  AnimatedSize(
                    duration: AppDimens.feedbackDuration,
                    alignment: Alignment.topCenter,
                    child: _expanded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Divider(
                                height: AppDimens.portalSpaceLg * 2,
                              ),
                              Text(strings.portalConditions, style: _meta),
                              for (final reason in reasons.skip(1))
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppDimens.portalSpaceXs,
                                  ),
                                  child: Text(reason, style: _body),
                                ),
                              if (item.eligibility != Eligibility.conditional &&
                                  concurrent != null)
                                PortalWarningLine(message: concurrent),
                              for (final warning in widget.warningMessages.skip(
                                1,
                              ))
                                PortalWarningLine(message: warning),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
