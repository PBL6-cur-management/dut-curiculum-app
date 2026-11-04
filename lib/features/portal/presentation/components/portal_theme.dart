import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

abstract final class PortalTheme {
  static ThemeData from(ThemeData base) {
    const body = TextStyle(
      fontSize: AppDimens.portalBodySize,
      height: AppDimens.portalLineHeight,
      color: AppColors.textPrimary,
    );
    const title = TextStyle(
      fontSize: AppDimens.portalSectionSize,
      height: AppDimens.portalLineHeight,
      fontWeight: FontWeight.w600,
      color: AppColors.brand,
    );
    const caption = TextStyle(
      fontSize: AppDimens.portalCaptionSize,
      height: AppDimens.portalLineHeight,
      color: AppColors.textSecondary,
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.brand,
        foregroundColor: AppColors.surface,
        centerTitle: true,
        toolbarHeight: AppDimens.portalToolbarHeight,
        titleTextStyle: title.copyWith(
          fontSize: AppDimens.portalTitleSize,
          color: AppColors.surface,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        titleMedium: title,
        titleLarge: title,
        bodyLarge: body,
        bodyMedium: body,
        bodySmall: caption,
        labelSmall: caption.copyWith(fontWeight: FontWeight.w600),
        labelLarge: body.copyWith(fontWeight: FontWeight.w600),
      ),
      iconTheme: base.iconTheme.copyWith(size: AppDimens.portalIconSize),
      cardTheme: const CardThemeData(
        color: AppColors.portalCourseSurface,
        elevation: AppDimens.portalFlatElevation,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimens.portalCardRadius),
          ),
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border(),
        collapsedShape: Border(),
        textColor: AppColors.brand,
        collapsedTextColor: AppColors.brand,
        tilePadding: EdgeInsets.symmetric(horizontal: AppDimens.portalSpaceSm),
      ),
      listTileTheme: const ListTileThemeData(
        minTileHeight: AppDimens.portalMenuRowMinHeight,
        iconColor: AppColors.brand,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.portalSummarySurface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.portalSpaceMd,
          vertical: AppDimens.portalSpaceXs,
        ),
        shape: const StadiumBorder(),
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: AppColors.surface,
        unselectedLabelColor: AppColors.textSecondary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            AppDimens.portalTouchMin,
            AppDimens.portalTouchMin,
          ),
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.portalSheetRadius),
          ),
        ),
      ),
    );
  }
}
