import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../../../auth/presentation/session/session_cubit.dart';
import '../../../auth/presentation/session/session_state.dart';
import '../../domain/model/home_tile.dart';
import '../components/feature_tile_grid.dart';
import '../components/home_tile_presentation.dart';
import '../components/profile_header_card.dart';
import '../components/today_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const _clockRefreshInterval = Duration(minutes: 1);
  late final Timer _clock;
  int _nowMs = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clock = Timer.periodic(_clockRefreshInterval, (_) => _refreshClock());
  }

  void _refreshClock() {
    if (mounted) {
      setState(() => _nowMs = DateTime.now().millisecondsSinceEpoch);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshClock();
    }
  }

  @override
  void dispose() {
    _clock.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<SessionCubit, SessionState>(
    builder: (context, state) {
      final user = state.user;
      if (user == null) {
        return const LoadingSkeleton();
      }
      final strings = AppLocalizations.of(context);
      return SafeArea(
        bottom: false,
        child: ListView(
          key: const PageStorageKey(RoutePaths.home),
          padding: const EdgeInsets.all(AppDimens.homeInset),
          children: [
            ProfileHeaderCard(
              fullName: user.fullName,
              subtitle: user.email ?? user.username,
              onBellTap: () => context.push(RoutePaths.notifications),
            ),
            const SizedBox(height: AppDimens.homeGap),
            TodayCard(nowMs: _nowMs),
            const SizedBox(height: AppDimens.homeGap),
            FeatureTileGrid(
              tiles: HomeTile.values
                  .map(
                    (tile) => (
                      icon: tile.icon,
                      label: tile.label(strings),
                      onTap: () {
                        context.push(tile.destination);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      );
    },
  );
}
