import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/widgets/app_page.dart';
import '../components/change_password_form.dart';
import '../session/session_cubit.dart';
import '../session/session_state.dart';
import 'change_password_cubit.dart';
import 'change_password_state.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final forced = context.select<SessionCubit, bool>(
      (session) => session.state.user?.mustChangePassword ?? false,
    );
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.isSuccess) {
          final session = context.read<SessionCubit>();
          if (session.state.status != SessionStatus.authenticated) {
            return;
          }
          session.passwordChanged();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(strings.passwordChanged)));
          if (!forced && context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.home);
          }
        }
      },
      builder: (context, state) => PopScope(
        canPop: !forced && !state.isSubmitting,
        child: AppPage(
          appBar: AppBar(
            title: Text(strings.changePassword),
            automaticallyImplyLeading: !forced && !state.isSubmitting,
          ),
          body: SafeArea(
            child: ChangePasswordForm(
              forced: forced,
              isSubmitting: state.isSubmitting,
              errorMessage: state.errorMessage,
              onSubmit: context.read<ChangePasswordCubit>().submit,
            ),
          ),
        ),
      ),
    );
  }
}
