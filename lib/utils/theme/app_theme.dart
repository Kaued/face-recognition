import 'package:face_recognition/utils/theme/theme_colors.dart';
import 'package:face_recognition/utils/theme/theme_text.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().copyWith().textTheme.copyWith(
          titleMedium: ThemeText.titleMedium,
          titleLarge: ThemeText.titleLarge,
        ),
    primaryColor: ThemeColors.primary,
  );
}
