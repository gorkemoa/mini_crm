import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_text_styles.dart';

abstract class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme = isLight
        ? const ColorScheme.light(
            primary: AppColors.primary,
            primaryContainer: AppColors.primaryContainer,
            secondary: AppColors.primaryLight,
            surface: AppColors.surfaceLight,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimaryLight,
            onError: Colors.white,
            outline: AppColors.borderLight,
          )
        : const ColorScheme.dark(
            primary: AppColors.primaryLight,
            primaryContainer: Color(0xFF312E81),
            secondary: AppColors.primary,
            surface: AppColors.surfaceDark,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimaryDark,
            onError: Colors.white,
            outline: AppColors.borderDark,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isLight ? AppColors.backgroundLight : AppColors.backgroundDark,
      fontFamily: 'Inter',

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        foregroundColor: isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: isLight ? AppColors.shadowLight : AppColors.shadowDark,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.surfaceVariantLight : AppColors.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: isLight ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isLight ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.navLabel.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.navLabel,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isLight ? AppColors.surfaceVariantLight : AppColors.surfaceVariantDark,
        labelStyle: AppTextStyles.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.chip),
        ),
        side: BorderSide.none,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.borderLight : AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.dialog),
        ),
        elevation: 4,
      ),
    );
  }
}
