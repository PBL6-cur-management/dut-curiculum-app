import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dut_curriculum_app/core/validation_exception.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../domain/use_case/auth_use_cases.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._strings) : super(const LoginState());

  final AuthUseCases _auth;
  final AppLocalizations _strings;

  Future<void> submit(String username, String password) async {
    if (state.isSubmitting) {
      return;
    }
    emit(const LoginState(isSubmitting: true));
    try {
      if (username.trim().isEmpty || password.isEmpty) {
        throw ValidationException(_strings.requiredCredentials);
      }
      final user = await _auth.login(username.trim(), password);
      if (!isClosed) {
        emit(LoginState(user: user));
      }
    } catch (error) {
      if (!isClosed) {
        emit(LoginState(errorMessage: error.toString()));
      }
    }
  }
}
