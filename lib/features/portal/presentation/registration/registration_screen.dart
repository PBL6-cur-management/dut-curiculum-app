import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../domain/model/eligibility_item.dart';
import '../../domain/model/eligibility_report.dart';
import '../components/eligibility_item_card.dart';
import '../components/portal_disclosure.dart';
import '../components/portal_page.dart';
import '../components/portal_section_header.dart';
import '../components/portal_state_panel.dart';
import '../components/portal_tabs.dart';
import '../components/portal_warning_line.dart';
import 'registration_cubit.dart';
import 'registration_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.semesterCode});
  final String semesterCode;
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _showBlocked = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.portalEligibilityTitle,
      body: BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          if (state.errorMessage case final message?)
            return PortalStatePanel(
              message: message,
              isError: true,
              onRetry: context.read<RegistrationCubit>().load,
            );
          final report = state.report;
          if (report == null)
            return PortalStatePanel(
              message: strings.noData,
              onRetry: context.read<RegistrationCubit>().load,
            );
          final selected = _showBlocked ? state.blocked : state.allowed;
          final allCompleted =
              report.items.isNotEmpty &&
              report.items.every((item) => item.completed);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.portalPageInset,
                  AppDimens.portalSpaceMd,
                  AppDimens.portalPageInset,
                  AppDimens.portalSpaceSm,
                ),
                child: Text(
                  strings.portalEligibilityAdvice,
                  style: const TextStyle(
                    fontSize: AppDimens.portalMetaSize,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              PortalTabs(
                labels: [
                  strings.registrationAllowed,
                  strings.registrationBlocked,
                ],
                counts: [state.allowed.length, state.blocked.length],
                selected: _showBlocked ? 1 : 0,
                onSelected: (index) =>
                    setState(() => _showBlocked = index == 1),
              ),
              Expanded(
                child: ListView(
                  key: PageStorageKey(_showBlocked),
                  padding: const EdgeInsets.all(AppDimens.portalPageInset),
                  children: [
                    if (report.items.isEmpty)
                      PortalStatePanel(message: strings.noData)
                    else if (allCompleted)
                      PortalStatePanel(message: strings.portalAllCompleted)
                    else if (selected.isEmpty)
                      PortalStatePanel(message: strings.portalNoCandidates),
                    for (final item in selected) _item(context, item, report),
                    if (state.unknown.isNotEmpty) ...[
                      PortalSectionHeader(
                        title: strings.portalUnknownEligibility,
                      ),
                      for (final item in state.unknown)
                        _item(context, item, report),
                    ],
                    if (report.warnings.isNotEmpty)
                      PortalDisclosure(
                        key: const PageStorageKey('eligibility-warnings'),
                        title: strings.warningCount(report.warnings.length),
                        children: [
                          for (final warning in report.warnings)
                            PortalWarningLine(
                              message: strings.fieldValue(
                                '${warning.course.code} \u00b7 ${warning.course.name}',
                                warning.message,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _item(
    BuildContext context,
    EligibilityItem item,
    EligibilityReport report,
  ) {
    final warnings = [
      for (final warning in report.warnings)
        if (warning.course.id == item.course.id) warning.message,
    ];
    return EligibilityItemCard(
      key: ValueKey(item.itemId),
      item: item,
      warningMessages: warnings,
    );
  }
}
