import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../components/portal_page.dart';
import '../components/portal_state_panel.dart';
import '../context/portal_context_cubit.dart';
import 'plo_description_tile.dart';
import 'plos_cubit.dart';
import 'plos_state.dart';

class PlosScreen extends StatelessWidget {
  const PlosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.plos,
      body: BlocBuilder<PlosCubit, PlosState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          if (state.errorMessage case final message?)
            return PortalStatePanel(
              message: message,
              isError: true,
              onRetry: context.read<PlosCubit>().load,
            );
          if (state.items.isEmpty)
            return PortalStatePanel(message: strings.noPlos);
          final groups = state.items
              .map((item) => item.competencyGroup)
              .toSet();
          return ListView(
            padding: const EdgeInsets.all(AppDimens.portalPageInset),
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.portalSummarySurface,
                  borderRadius: BorderRadius.circular(
                    AppDimens.portalPanelRadius,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
                  child: Text(
                    strings.ploSummary(state.items.length, groups.length),
                    style: const TextStyle(
                      fontSize: AppDimens.portalPanelTitleSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brand,
                    ),
                  ),
                ),
              ),
              for (final group in groups) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppDimens.portalSpaceXl,
                    bottom: AppDimens.portalSpaceMd,
                  ),
                  child: Text(
                    group == null || group.trim().isEmpty
                        ? strings.other
                        : group,
                    style: const TextStyle(
                      fontSize: AppDimens.portalTermTitleSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                for (final (index, item) in state.items.indexed)
                  if (item.competencyGroup == group)
                    PloDescriptionTile(
                      key: ValueKey((
                        context.read<PortalContextCubit>().state.context,
                        group,
                        item.code,
                        index,
                      )),
                      code: item.code,
                      description: item.description,
                    ),
              ],
            ],
          );
        },
      ),
    );
  }
}
