import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/date_format.dart';
import 'home_surface.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({super.key, required this.nowMs});

  final int nowMs;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return HomeSurface(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: AppDimens.todayDateWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatWeekday(nowMs, strings),
                      style: const TextStyle(
                        fontSize: AppDimens.todayWeekdaySize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      strings.monthLabel(monthOf(nowMs)),
                      style: const TextStyle(
                        fontSize: AppDimens.todayMonthSize,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      formatDay(nowMs),
                      style: const TextStyle(
                        fontSize: AppDimens.dayFont,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand,
                        height: AppDimens.tileLabelLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                width: AppDimens.spaceLg,
                thickness: AppDimens.hairline,
                color: AppColors.textSecondary.withValues(
                  alpha: AppDimens.borderAlpha,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.edit_calendar_outlined,
                      size: AppDimens.todayIcon,
                      color: AppColors.brand,
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      strings.todayNoSchedule,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppDimens.todayMessageSize,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
