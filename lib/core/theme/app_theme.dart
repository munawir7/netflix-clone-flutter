import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
AppTheme._();

static ThemeData get darkTheme {
return ThemeData(
useMaterial3: true,
brightness: Brightness.dark,
scaffoldBackgroundColor: AppColors.background,
colorScheme: const ColorScheme.dark(
primary: AppColors.primary,
surface: AppColors.surface,
),
appBarTheme: const AppBarTheme(
backgroundColor: AppColors.background,
foregroundColor: AppColors.textPrimary,
elevation: 0,
),
inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: AppColors.surface,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(
AppConstantsPlaceholder.borderRadius,
),
),
),
);
}
}

class AppConstantsPlaceholder {
AppConstantsPlaceholder._();

static const double borderRadius = 8.0;
}
