import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import 'common/routes/app_router.dart';
import 'common/routes/go_router_refresh_stream.dart';
import 'common/theme/app_theme.dart';
import 'features/auth/presentation/session/session_cubit.dart';
import 'features/auth/presentation/session/session_state.dart';

class App extends StatefulWidget {
  const App({super.key, required this.session});

  final SessionCubit session;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final GoRouterRefreshStream _refresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _refresh = GoRouterRefreshStream(widget.session.stream);
    _router = buildRouter(widget.session, refresh: _refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.session.restore();
      }
    });
  }

  @override
  void dispose() {
    _router.dispose();
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: widget.session,
    child: BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final strings = lookupAppLocalizations(const Locale('vi'));
        final message =
            state.errorMessage ??
            (state.notice == SessionState.expiredNotice
                ? strings.sessionExpired
                : state.notice);
        if (message == null) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          _messengerKey.currentState?.showSnackBar(
            SnackBar(content: Text(message)),
          );
          widget.session.clearNotice();
        });
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messengerKey,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        theme: buildAppTheme(),
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    ),
  );
}
