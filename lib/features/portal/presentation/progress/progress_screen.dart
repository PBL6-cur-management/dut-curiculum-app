import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../domain/model/graduation_outcome.dart';
import '../components/credit_progress_card.dart';
import '../components/portal_disclosure.dart';
import '../components/portal_page.dart';
import '../components/portal_warning_line.dart';
import '../components/portal_state_panel.dart';
import '../components/portal_tabs.dart';
import '../components/result_row.dart';
import 'credit_breakdown.dart';
import 'progress_cubit.dart';
import 'progress_state.dart';

enum ProgressView { progress, results }

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressView _view = ProgressView.progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.progressResults,
      body: Column(
        children: [
          PortalTabs(
            labels: [strings.portalProgressTab, strings.portalResultsTab],
            selected: _view.index,
            onSelected: (selected) =>
                setState(() => _view = ProgressView.values[selected]),
          ),
          Expanded(
            child: BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, state) => _view == ProgressView.progress
                  ? _progress(context, state)
                  : _results(context, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress(BuildContext context, ProgressState state) {
    final strings = AppLocalizations.of(context);
    final retry = context.read<ProgressCubit>().load;
    if (state.graduationError case final message?) {
      return PortalStatePanel(message: message, isError: true, onRetry: retry);
    }
    final outcome = state.graduation;
    if (outcome case GraduationReviewed(:final result)) {
      return ListView(
        key: const PageStorageKey('progress'),
        padding: const EdgeInsets.all(AppDimens.portalPageInset),
        children: [
          CreditProgressCard(
            fraction: state.fraction,
            required: result.credits.requiredTotal,
            recognized: result.credits.recognizedTotal,
            missing: result.credits.missingTotal,
            compulsory: result.credits.compulsory,
            elective: result.credits.elective,
            free: result.credits.free,
          ),
          PortalDisclosure(
            key: const PageStorageKey('credit-breakdown'),
            title: strings.portalCreditBreakdown,
            children: [CreditBreakdown(result: result)],
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
        ],
      );
    }
    if (outcome case GraduationCannotAudit(:final message)) {
      return PortalStatePanel(message: message, onRetry: retry);
    }
    if (outcome is GraduationUnsupported) {
      return PortalStatePanel(message: strings.unsupportedResultVersion);
    }
    if (state.isLoading) return const LoadingSkeleton();
    return PortalStatePanel(message: strings.noData, onRetry: retry);
  }

  Widget _results(BuildContext context, ProgressState state) {
    final strings = AppLocalizations.of(context);
    final cubit = context.read<ProgressCubit>();
    if (!state.resultsLoaded && state.resultsError == null && state.isLoading) {
      return const LoadingSkeleton();
    }
    return ListView(
      key: const PageStorageKey('results'),
      padding: const EdgeInsets.all(AppDimens.portalPageInset),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
          child: Text(
            strings.portalHistoryScope,
            style: const TextStyle(
              fontSize: AppDimens.portalMetaSize,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (state.resultsLoaded && state.results.isEmpty)
          PortalStatePanel(message: strings.noData),
        for (final result in state.results)
          ResultRow(key: ValueKey(result.id), result: result),
        if (state.resultsError case final message?)
          PortalStatePanel(
            message: message,
            isError: true,
            onRetry: state.resultsLoaded && state.hasMore
                ? cubit.loadMore
                : cubit.load,
          ),
        if (state.isLoadingMore)
          const Center(child: CircularProgressIndicator()),
        if (state.hasMore && state.resultsError == null)
          TextButton(
            onPressed: state.isLoading || state.isLoadingMore
                ? null
                : cubit.loadMore,
            child: Text(strings.loadMore),
          ),
      ],
    );
  }
}
