import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../core/di/getit_utils.dart';
import '../../features/auth/presentation/change_password/change_password_cubit.dart';
import '../../features/auth/presentation/change_password/change_password_screen.dart';
import '../../features/auth/presentation/login/login_cubit.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/session/session_cubit.dart';
import '../../features/auth/presentation/session/session_state.dart';
import '../../features/auth/presentation/splash/startup_splash_screen.dart';
import '../../features/portal/presentation/context/portal_context_cubit.dart';
import '../../features/portal/presentation/context/portal_route.dart';
import '../../features/portal/presentation/curriculum/curriculum_cubit.dart';
import '../../features/portal/presentation/curriculum/curriculum_screen.dart';
import '../../features/portal/presentation/graduation/graduation_cubit.dart';
import '../../features/portal/presentation/graduation/graduation_screen.dart';
import '../../features/portal/presentation/overview/portal_overview_screen.dart';
import '../../features/portal/presentation/plos/plos_cubit.dart';
import '../../features/portal/presentation/plos/plos_screen.dart';
import '../../features/portal/presentation/progress/progress_cubit.dart';
import '../../features/portal/presentation/progress/progress_screen.dart';
import '../../features/portal/presentation/registration/registration_cubit.dart';
import '../../features/portal/presentation/registration/registration_screen.dart';
import '../../features/portal/presentation/syllabus/syllabus_cubit.dart';
import '../../features/portal/presentation/syllabus/syllabus_screen.dart';
import '../../features/shell/domain/model/home_tile.dart';
import '../../features/shell/presentation/home/home_screen.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/shell/presentation/placeholder/placeholder_screen.dart';
import '../../features/shell/presentation/profile/profile_screen.dart';
import '../theme/app_dimens.dart';
import '../widgets/error_panel.dart';
import 'go_router_refresh_stream.dart';
import 'route_paths.dart';

GoRouter buildRouter(
  SessionCubit session, {
  required GoRouterRefreshStream refresh,
}) => GoRouter(
  initialLocation: RoutePaths.splash,
  refreshListenable: refresh,
  redirect: (context, routerState) {
    final state = session.state;
    final path = routerState.uri.path;
    if (state.status == SessionStatus.unknown) {
      return path == RoutePaths.splash ? null : RoutePaths.splash;
    }
    if (state.status == SessionStatus.unauthenticated) {
      return path == RoutePaths.login ? null : RoutePaths.login;
    }
    if (state.user?.mustChangePassword ?? false) {
      return path == RoutePaths.changePassword
          ? null
          : RoutePaths.changePassword;
    }
    if (path == RoutePaths.splash || path == RoutePaths.login) {
      return RoutePaths.home;
    }
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: ErrorPanel(
          message:
              state.error?.toString() ??
              AppLocalizations.of(context).unknownTile,
          onRetry: () => context.go(RoutePaths.home),
        ),
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const StartupSplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<LoginCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.changePassword,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ChangePasswordCubit>(),
        child: const ChangePasswordScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.profile,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<PortalContextCubit>()..load(),
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.placeholder,
      redirect: (context, state) =>
          state.pathParameters[RoutePaths.placeholderTileParameter] ==
              HomeTile.curriculum.name
          ? RoutePaths.curriculum
          : null,
      builder: (context, state) {
        final name = state.pathParameters[RoutePaths.placeholderTileParameter];
        if (name == RoutePaths.notificationsTile) {
          return PlaceholderScreen(
            tile: HomeTile.assistant,
            title: AppLocalizations.of(context).notifications,
          );
        }
        for (final tile in HomeTile.values) {
          if (tile.name == name) {
            return PlaceholderScreen(tile: tile);
          }
        }
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).appTitle)),
          body: Padding(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: ErrorPanel(
              message: AppLocalizations.of(context).unknownTile,
            ),
          ),
        );
      },
    ),
    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (_) => getIt<PortalContextCubit>()..load(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: RoutePaths.curriculum,
          builder: (context, state) => const PortalOverviewScreen(),
        ),
        GoRoute(
          path: RoutePaths.curriculumProgram,
          builder: (context, state) => PortalRoute(
            builder: (portal, _) => BlocProvider(
              key: ValueKey(portal),
              create: (_) => getIt<CurriculumCubit>(param1: portal)..load(),
              child: const CurriculumScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.syllabus,
          builder: (context, state) {
            final itemId =
                state.pathParameters[RoutePaths.syllabusItemParameter]!;
            return PortalRoute(
              builder: (portal, _) => BlocProvider(
                key: ValueKey((portal, itemId)),
                create: (_) =>
                    getIt<SyllabusCubit>(param1: portal, param2: itemId)
                      ..load(),
                child: const SyllabusScreen(),
              ),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.plos,
          builder: (context, state) => PortalRoute(
            builder: (portal, _) => BlocProvider(
              key: ValueKey(portal),
              create: (_) => getIt<PlosCubit>(param1: portal)..load(),
              child: const PlosScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.progress,
          builder: (context, state) => PortalRoute(
            builder: (portal, _) => BlocProvider(
              key: ValueKey(portal),
              create: (_) => getIt<ProgressCubit>(param1: portal)..load(),
              child: const ProgressScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.registration,
          builder: (context, state) => PortalRoute(
            builder: (portal, portalState) => BlocProvider(
              key: ValueKey(portal),
              create: (_) => getIt<RegistrationCubit>(param1: portal)..load(),
              child: RegistrationScreen(
                semesterCode: portalState.overview!.semester!.code,
              ),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.graduation,
          builder: (context, state) => PortalRoute(
            builder: (portal, _) => BlocProvider(
              key: ValueKey(portal),
              create: (_) => getIt<GraduationCubit>(param1: portal)..load(),
              child: const GraduationScreen(),
            ),
          ),
        ),
      ],
    ),
  ],
);
