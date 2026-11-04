import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/login_background.dart';
import '../components/login_form_sheet.dart';
import '../components/login_landing_content.dart';
import '../session/session_cubit.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _sheetOpen = false;

  Future<void> _openForm() async {
    if (_sheetOpen) {
      return;
    }
    final cubit = context.read<LoginCubit>();
    _sheetOpen = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) => LoginFormSheet(
            isSubmitting: state.isSubmitting,
            errorMessage: state.errorMessage,
            onSubmit: cubit.submit,
          ),
        ),
      ),
    );
    _sheetOpen = false;
  }

  @override
  Widget build(BuildContext context) => BlocListener<LoginCubit, LoginState>(
    listener: (context, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
      final user = state.user;
      if (user != null) {
        if (_sheetOpen) {
          Navigator.of(context).pop();
        }
        context.read<SessionCubit>().signedIn(user);
      }
    },
    child: Scaffold(
      body: LoginBackground(child: LoginLandingContent(onLogin: _openForm)),
    ),
  );
}
