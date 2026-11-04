import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../../auth/presentation/session/session_cubit.dart';
import '../../../auth/presentation/session/session_state.dart';
import '../../../portal/domain/model/enrollment_type.dart';
import '../../../portal/presentation/context/portal_context_cubit.dart';
import '../../../portal/presentation/context/portal_context_state.dart';
import '../components/profile_hero.dart';
import '../components/profile_section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final strings = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.logout),
        content: Text(strings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.logout),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<SessionCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<SessionCubit, SessionState>(
    builder: (context, session) {
      final user = session.user;
      if (user == null) {
        return const LoadingSkeleton();
      }
      final strings = AppLocalizations.of(context);
      return Stack(
        children: [
          SafeArea(
            bottom: false,
            child: BlocBuilder<PortalContextCubit, PortalContextState>(
              builder: (context, portal) {
                final student = portal.overview?.student;
                final programs = portal.overview?.programs ?? const [];
                final primary = programs
                    .where((p) => p.enrollmentType == EnrollmentType.primary)
                    .firstOrNull;
                final missing = portal.isLoading
                    ? strings.loading
                    : strings.noValue;
                return ListView(
                  key: const PageStorageKey(RoutePaths.profile),
                  padding: const EdgeInsets.all(AppDimens.homeInset),
                  children: [
                    ProfileHero(
                      fullName: user.fullName,
                      subtitle: user.email ?? user.username,
                    ),
                    const SizedBox(height: AppDimens.homeGap),
                    ProfileSectionCard(
                      title: strings.basicInfo,
                      rows: [
                        (strings.birthDate, strings.noValue),
                        (strings.gender, strings.noValue),
                        (strings.phoneNumber, strings.noValue),
                        (strings.personalEmail, strings.noValue),
                      ],
                    ),
                    const SizedBox(height: AppDimens.homeGap),
                    ProfileSectionCard(
                      title: strings.academicInfo,
                      rows: [
                        (strings.studentCode, student?.studentCode ?? missing),
                        (strings.major, student?.major ?? missing),
                        (strings.cohort, student?.cohortCode ?? missing),
                        (strings.programShort, primary?.programName ?? missing),
                        (
                          strings.office365Account,
                          user.email ?? strings.noValue,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            right: AppDimens.homeInset,
            bottom: AppDimens.homeInset,
            child: FloatingActionButton(
              tooltip: strings.logout,
              shape: const CircleBorder(),
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.surface,
              onPressed: session.isSigningOut
                  ? null
                  : () => _confirmLogout(context),
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      );
    },
  );
}
