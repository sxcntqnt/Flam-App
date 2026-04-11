import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';

class PoppinsTextStyles {
  static const Color primaryColor = CustomTheme.appColor;
  static const Color accentColor = Color(0xFFFB8A00);
  static const Color blue500 = Color(0xFF2196F3);
  static const Color red500 = Color(0xFFF44336);
  static const Color green600 = Color(0xFF4CAF50);
  static const Color yellow600 = Color(0xFFFFEB3B);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
  static const Color white = Colors.white;

  static const String fontFamily = 'Poppins';

  static TextStyle titleXLargeRegular = const TextStyle(
    fontSize: 34,
    height: 41 / 34,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: primaryColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle titleLargeRegular = const TextStyle(
    fontSize: 28,
    height: 34 / 28,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.yellow,
    fontWeight: FontWeight.w400,
  );

  static TextStyle titleMediumRegular = const TextStyle(
    fontSize: 20,
    height: 30 / 24,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle titleSmallRegular = const TextStyle(
    fontSize: 22,
    height: 30 / 22,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.orange,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headlineLargeRegular = const TextStyle(
    fontSize: 20,
    height: 26 / 20,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.red,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headlineMediumRegular = const TextStyle(
    fontSize: 18,
    height: 20 / 16,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle headlineSmallRegular = const TextStyle(
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subheadLargeRegular = const TextStyle(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Colors.green,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subheadSmallRegular = const TextStyle(
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: Color(0xFFA0A0A0),
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyLargeRegular = const TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: gray700,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMediumRegular = const TextStyle(
    fontSize: 14,
    height: 22 / 14,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: gray800,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySmallRegular = const TextStyle(
    fontSize: 12,
    height: 18 / 12,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: gray900,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelLargeRegular = const TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: primaryColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelMediumRegular = const TextStyle(
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: CustomTheme.darkColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelSmallRegular = const TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: primaryColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle captionRegular = const TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0,
    fontFamily: fontFamily,
    color: gray700,
    fontWeight: FontWeight.w400,
  );
}
