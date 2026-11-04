import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/error_panel.dart';
import 'password_input.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
    required this.isSubmitting,
    required this.forced,
    required this.onSubmit,
    this.errorMessage,
  });

  final bool isSubmitting;
  final bool forced;
  final String? errorMessage;
  final void Function(String current, String password, String confirm) onSubmit;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.isSubmitting) {
      widget.onSubmit(_current.text, _password.text, _confirmation.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      children: [
        if (widget.forced) ...[
          Text(strings.forcedPasswordChange),
          const SizedBox(height: AppDimens.largeGap),
        ],
        PasswordInput(
          controller: _current,
          label: strings.currentPassword,
          enabled: !widget.isSubmitting,
        ),
        const SizedBox(height: AppDimens.gap),
        PasswordInput(
          controller: _password,
          label: strings.newPassword,
          enabled: !widget.isSubmitting,
          isNewPassword: true,
        ),
        const SizedBox(height: AppDimens.smallGap),
        Text(
          strings.passwordPolicy,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimens.gap),
        PasswordInput(
          controller: _confirmation,
          label: strings.confirmPassword,
          enabled: !widget.isSubmitting,
          isNewPassword: true,
          onSubmitted: (_) => _submit(),
        ),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: AppDimens.gap),
          ErrorPanel(message: widget.errorMessage!),
        ],
        const SizedBox(height: AppDimens.largeGap),
        FilledButton(
          onPressed: widget.isSubmitting ? null : _submit,
          child: Text(
            widget.isSubmitting ? strings.loading : strings.changePassword,
          ),
        ),
      ],
    );
  }
}
