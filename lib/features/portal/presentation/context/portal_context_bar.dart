import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'portal_context_cubit.dart';
import 'portal_context_state.dart';
import 'portal_context_sheet.dart';

class PortalContextBar extends StatelessWidget {
  const PortalContextBar({super.key, this.onBeforeChange});
  final VoidCallback? onBeforeChange;

  static const _meta = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    color: AppColors.textSecondary,
  );
  static const _separator = '\u2022';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PortalContextCubit, PortalContextState>(
        builder: (context, state) {
          final strings = AppLocalizations.of(context);
          final program = state.selectedProgram;
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.portalSpaceSm,
              AppDimens.portalSpaceSm,
              AppDimens.portalSpaceSm,
              0,
            ),
            child: Semantics(
              label: strings.portalChangeContext,
              button: true,
              child: Material(
                color: AppColors.portalSummarySurface,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(
                  AppDimens.portalPanelRadius,
                ),
                child: InkWell(
                  onTap: () => showPortalContextSheet(
                    context,
                    onBeforeChange: onBeforeChange,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppDimens.portalContextMinHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.portalSpaceLg,
                        vertical: AppDimens.portalSpaceSm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  program?.programName ??
                                      strings.portalAppliedCurriculum,
                                  maxLines: AppDimens.portalContextTitleLines,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: AppDimens.portalSectionSize,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.brand,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.portalSpaceXs),
                                Wrap(
                                  spacing: AppDimens.portalSpaceSm,
                                  children: [
                                    Text(
                                      state.overview?.semester?.code ??
                                          strings.emptyValue,
                                      style: _meta,
                                    ),
                                    const Text(_separator, style: _meta),
                                    Text(
                                      program?.versionNumber == null
                                          ? strings.noVersion
                                          : strings.fieldValue(
                                              strings.version,
                                              program!.versionNumber!,
                                            ),
                                      style: _meta,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.expand_more, color: AppColors.brand),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
