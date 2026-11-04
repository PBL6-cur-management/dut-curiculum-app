import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dut_curriculum_app/core/validation_exception.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../domain/model/password_policy.dart';
import '../../domain/use_case/auth_use_cases.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._auth, this._strings)
    : super(const ChangePasswordState());

  final AuthUseCases _auth;
  final AppLocalizations _strings;

  Future<void> submit(
    String currentPassword,
    String newPassword,
    String confirmation,
  ) async {
    if (state.isSubmitting) {
      return;
    }
    emit(const ChangePasswordState(isSubmitting: true));
    try {
      if (currentPassword.isEmpty) {
        throw ValidationException(_strings.currentPasswordRequired);
      }
      if (!PasswordPolicy.accepts(newPassword)) {
        throw ValidationException(_strings.passwordPolicy);
      }
      if (newPassword != confirmation) {
        throw ValidationException(_strings.passwordMismatch);
      }
      await _auth.changePassword(currentPassword, newPassword);
      if (!isClosed) {
        emit(const ChangePasswordState(isSuccess: true));
      }
    } catch (error) {
      if (!isClosed) {
        emit(ChangePasswordState(errorMessage: error.toString()));
      }
    }
  }
}
