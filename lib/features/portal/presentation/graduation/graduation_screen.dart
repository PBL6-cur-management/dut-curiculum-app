import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/date_format.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../domain/model/graduation_outcome.dart';
import '../../domain/model/graduation_result.dart';
import '../../domain/model/shortfall_category.dart';
import '../components/conclusion_banner.dart';
import '../components/portal_disclosure.dart';
import '../components/portal_labels.dart';
import '../components/portal_page.dart';
import '../components/portal_pill_link.dart';
import '../components/portal_state_panel.dart';
import '../components/portal_warning_line.dart';
import '../components/shortfall_group.dart';
import 'graduation_cubit.dart';
import 'graduation_state.dart';

class GraduationScreen extends StatelessWidget {
  const GraduationScreen({super.key});

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.graduation,
      body: BlocBuilder<GraduationCubit, GraduationState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          if (state.errorMessage case final message?)
            return PortalStatePanel(
              message: message,
              isError: true,
              onRetry: context.read<GraduationCubit>().load,
            );
          return switch (state.outcome) {
            GraduationReviewed(:final result) => _reviewed(context, result),
            GraduationCannotAudit(:final message) => PortalStatePanel(
              message: message,
              onRetry: context.read<GraduationCubit>().load,
            ),
            GraduationUnsupported() => PortalStatePanel(
              message: strings.unsupportedResultVersion,
            ),
            null => PortalStatePanel(message: strings.noData),
          };
        },
      ),
    );
  }

  Widget _reviewed(BuildContext context, GraduationResult result) {
    final strings = AppLocalizations.of(context);
    final tag = result.conclusion.tag(strings);
    return ListView(
      padding: const EdgeInsets.all(AppDimens.portalPageInset),
      children: [
        ConclusionBanner(
          label: tag.label,
          color: tag.color,
          lines: [strings.graduationInfo],
        ),
        for (final category in ShortfallCategory.values)
          if (result.shortfalls.any((item) => item.category == category)) ...[
            ShortfallGroup(
              title: category.label(strings),
              items: [
                for (final item in result.shortfalls)
                  if (item.category == category)
                    (title: item.title, message: item.message),
              ],
            ),
            if (category == ShortfallCategory.totalCredits)
              Text(
                strings.requiredEarnedMissing(
                  formatDecimal(result.credits.requiredTotal),
                  formatDecimal(result.credits.recognizedTotal),
                  formatDecimal(result.credits.missingTotal),
                ),
                style: _meta,
              ),
          ],
        if (result.shortfalls.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.portalSpaceLg),
            child: Text(strings.portalNoShortfalls, style: _meta),
          ),
        if (result.warnings.isNotEmpty)
          PortalDisclosure(
            key: const PageStorageKey('warnings'),
            title: strings.warningCount(result.warnings.length),
            children: [
              for (final warning in result.warnings)
                PortalWarningLine(message: warning.message),
            ],
          ),
        PortalDisclosure(
          key: const PageStorageKey('evaluation-basis'),
          title: strings.portalEvaluationBasis,
          children: [
            Text(
              strings.evaluatedAt(formatTimestamp(result.evaluatedAtMs)),
              style: _meta,
            ),
            Text(
              strings.fieldValue(strings.version, result.versionNumber),
              style: _meta,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppDimens.portalSpaceLg),
          child: PortalPillLink(
            icon: Icons.bar_chart_outlined,
            label: strings.portalCreditBreakdown,
            onTap: () {
              context.push(RoutePaths.progress);
            },
          ),
        ),
      ],
    );
  }
}
