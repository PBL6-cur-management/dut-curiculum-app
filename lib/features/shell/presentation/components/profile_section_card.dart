import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import 'home_surface.dart';

class ProfileSectionCard extends StatefulWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<(String, String)> rows;

  @override
  State<ProfileSectionCard> createState() => _ProfileSectionCardState();
}

class _ProfileSectionCardState extends State<ProfileSectionCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return HomeSurface(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              expanded: _expanded,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceSm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: AppDimens.profileSectionTitleSize,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_expanded) ...[
              const Divider(
                height: AppDimens.spaceLg,
                thickness: AppDimens.profileRuleThickness,
                color: AppColors.textPrimary,
              ),
              for (final (label, value) in widget.rows)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.profileRowGap / 2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: AppDimens.profileLabelWidth,
                        child: Text(
                          strings.labelWithColon(label),
                          style: const TextStyle(
                            fontSize: AppDimens.profileRowSize,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: AppDimens.profileRowSize,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
