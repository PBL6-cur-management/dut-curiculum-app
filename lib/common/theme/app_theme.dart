import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_component_theme.dart';
import 'app_dimens.dart';

ThemeData buildAppTheme() {
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppDimens.loginCardRadius),
  );
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.pageBackground,
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: shape,
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, AppDimens.buttonHeight),
        shape: shape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.pageBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.loginCardRadius),
        borderSide: BorderSide.none,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.pageBackground,
      foregroundColor: AppColors.brand,
    ),
  );
}

ThemeData buildComponentTheme(ThemeData base) {
  if (base.extension<AppComponentTheme>() != null) {
    return base;
  }
  final border = BorderSide(
    color: AppColors.textSecondary.withValues(alpha: AppDimens.borderAlpha),
    width: AppDimens.hairline,
  );
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
    side: border,
  );
  final textTheme = base.textTheme.apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  );
  final buttonStyle = FilledButton.styleFrom(
    minimumSize: const Size(0, AppDimens.controlHeight),
    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
    ),
    animationDuration: AppDimens.feedbackDuration,
    elevation: 0,
  );
  return base.copyWith(
    extensions: [...base.extensions.values, const AppComponentTheme()],
    textTheme: textTheme.copyWith(
      titleLarge: textTheme.titleLarge?.copyWith(
        fontSize: AppDimens.titleSize,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontSize: AppDimens.sectionSize,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(
        fontSize: AppDimens.bodySize,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontSize: AppDimens.bodySize,
        height: AppDimens.bodyLineHeight,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        fontSize: AppDimens.bodySize,
        height: AppDimens.bodyLineHeight,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        fontSize: AppDimens.captionSize,
        color: AppColors.textSecondary,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        fontSize: AppDimens.captionSize,
        color: AppColors.textSecondary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        side: border,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: border.color,
      thickness: AppDimens.hairline,
      space: AppDimens.hairline,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceXs,
      ),
      minVerticalPadding: AppDimens.spaceSm,
      minTileHeight: AppDimens.controlHeight,
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
      titleTextStyle: textTheme.titleSmall?.copyWith(
        fontSize: AppDimens.bodySize,
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
        height: AppDimens.bodyLineHeight,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      side: border,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      labelPadding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      labelStyle: const TextStyle(
        fontSize: AppDimens.captionSize,
        color: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.brand.withValues(alpha: AppDimens.tintAlpha),
      showCheckmark: true,
    ),
    filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppDimens.controlHeight),
        shape: shape,
        side: border,
        animationDuration: AppDimens.feedbackDuration,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, AppDimens.controlHeight),
        shape: shape.copyWith(side: BorderSide.none),
        animationDuration: AppDimens.feedbackDuration,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        minimumSize: const Size(0, AppDimens.controlHeight),
        shape: shape,
        side: border,
        foregroundColor: AppColors.brand,
        selectedForegroundColor: AppColors.brand,
        selectedBackgroundColor: AppColors.brand.withValues(
          alpha: AppDimens.tintAlpha,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.all(AppDimens.spaceMd),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        borderSide: border,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        borderSide: border,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.brand,
          width: AppDimens.focusBorder,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      tilePadding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      childrenPadding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      backgroundColor: AppColors.surface,
      collapsedBackgroundColor: AppColors.surface,
      shape: shape,
      collapsedShape: shape,
      expansionAnimationStyle: const AnimationStyle(
        duration: AppDimens.feedbackDuration,
        curve: Curves.easeInOut,
      ),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: const WidgetStatePropertyAll(AppColors.pageBackground),
      headingTextStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      dataTextStyle: textTheme.bodyMedium,
      horizontalMargin: AppDimens.spaceMd,
      columnSpacing: AppDimens.spaceLg,
      headingRowHeight: AppDimens.tableRowHeight,
      dataRowMinHeight: AppDimens.tableRowHeight,
      dataRowMaxHeight: AppDimens.tableMaxRowHeight,
      dividerThickness: AppDimens.hairline,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.pageBackground,
      foregroundColor: AppColors.brand,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: AppDimens.spaceLg,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: AppDimens.titleSize,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
