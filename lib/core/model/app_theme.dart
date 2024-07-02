import 'package:flutter/material.dart';

class AppColors {
  static const pinkMain = Color(0xFFF3E5F5);
  static const pinkXxl = Color(0xFFEA80FC);
  static const pinkXl = Color(0xFFBA68C8);
  static const pinkL = Color(0xFFE1BEE7);
  static const purple = Color(0xFF6A1B9A);
  static const blackL = Color.fromRGBO(47, 47, 47, 1);
  static const blackXl = Color(0xFF222222);
  static const blackXxl = Color.fromRGBO(28, 28, 28, 1);
}

class AppText {
  static const header = TextStyle(
    color: AppColors.pinkMain,
    fontWeight: FontWeight.w500,
    fontSize: 32,
    decoration: TextDecoration.none,
  );

  static const btnText = TextStyle(
    color: AppColors.pinkMain,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    decoration: TextDecoration.none,
  );

  static const textfieldText = TextStyle(
    color: AppColors.blackXl,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    decoration: TextDecoration.none,
  );

  static const statusCommonText = TextStyle(
    color: AppColors.pinkMain,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    decoration: TextDecoration.none,
  );

  static const statusAccentText = TextStyle(
    color: AppColors.pinkXl,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    decoration: TextDecoration.none,
  );
}

class AppTheme {
  static final themeData = ThemeData(
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(AppColors.pinkXxl),
      ),
    ),
  );
}
