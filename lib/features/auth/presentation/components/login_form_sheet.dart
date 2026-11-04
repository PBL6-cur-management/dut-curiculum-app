import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/error_panel.dart';
import '../../../../common/widgets/section_header.dart';
import 'password_input.dart';

class LoginFormSheet extends StatefulWidget {
  const LoginFormSheet({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
    this.errorMessage,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final void Function(String username, String password) onSubmit;

  @override
  State<LoginFormSheet> createState() => _LoginFormSheetState();
}

class _LoginFormSheetState extends State<LoginFormSheet> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.isSubmitting) {
      widget.onSubmit(_username.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.gap,
          AppDimens.pagePadding,
          MediaQuery.viewInsetsOf(context).bottom + AppDimens.pagePadding,
        ),
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(title: strings.submitLogin),
              TextField(
                controller: _username,
                autofocus: true,
                enabled: !widget.isSubmitting,
                autocorrect: false,
                autofillHints: const [AutofillHints.username],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: strings.username),
              ),
              const SizedBox(height: AppDimens.gap),
              PasswordInput(
                controller: _password,
                label: strings.password,
                enabled: !widget.isSubmitting,
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
                  widget.isSubmitting ? strings.loading : strings.submitLogin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
