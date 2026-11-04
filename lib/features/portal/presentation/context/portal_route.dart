import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../domain/model/portal_context.dart';
import '../components/portal_page.dart';
import '../components/portal_state_panel.dart';
import 'portal_context_cubit.dart';
import 'portal_context_state.dart';

class PortalRoute extends StatelessWidget {
  const PortalRoute({super.key, required this.builder, this.onBack});
  final Widget Function(PortalContext portal, PortalContextState state) builder;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PortalContextCubit, PortalContextState>(
        builder: (context, state) {
          final strings = AppLocalizations.of(context);
          final portal = state.context;
          if (!state.isLoading &&
              state.errorMessage == null &&
              state.semesters.isNotEmpty &&
              portal != null) {
            return builder(portal, state);
          }
          final message =
              state.errorMessage ??
              (state.overview?.student == null
                  ? strings.noStudentLinked
                  : state.semesters.isEmpty || state.overview?.semester == null
                  ? strings.portalMissingSemester
                  : strings.portalNoApplicableProgram);
          return PortalPage(
            title: strings.curriculum,
            onBack: onBack ?? () => context.go(RoutePaths.curriculum),
            body: state.isLoading
                ? const LoadingSkeleton()
                : PortalStatePanel(
                    message: message,
                    isError: state.errorMessage != null,
                    onRetry: context.read<PortalContextCubit>().load,
                  ),
          );
        },
      );
}
