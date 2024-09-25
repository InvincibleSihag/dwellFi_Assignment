
import 'package:dwell_fi_assignment/core/constants/color_palette.dart';
import 'package:flutter/material.dart';

ThemeData baseTheme = ThemeData(
  useMaterial3: true,

  appBarTheme: AppBarTheme(
    backgroundColor: ColorPalette.appBarColor,
    foregroundColor: ColorPalette.subTextColor,
  ),

  primaryColor: ColorPalette.baseSecondary,
  scaffoldBackgroundColor: ColorPalette.scaffoldBackgroundColor,
  secondaryHeaderColor: ColorPalette.baseSecondary,

  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
    bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 20),
    titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 24),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 16,
        // fontFamily: 'gilroy',
      ),
      visualDensity: const VisualDensity(vertical: 1.5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),),
      foregroundColor: Colors.white,
      backgroundColor: ColorPalette.baseSecondary,
    ),
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(color: Colors.black87),
    menuStyle: MenuStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          side: BorderSide(color: ColorPalette.baseSecondary),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      gapPadding: 0.0,
      borderSide: BorderSide(color: ColorPalette.baseSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      gapPadding: 0.0,
      borderSide: BorderSide(color: ColorPalette.baseSecondary),
    ),
    activeIndicatorBorder: BorderSide(color: ColorPalette.baseSecondary),
    labelStyle: TextStyle(color: ColorPalette.baseSecondary),
    hintStyle: TextStyle(color: ColorPalette.hintColor),
    fillColor: Colors.white,
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: ColorPalette.baseSecondary,
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ColorPalette.subTextColor,
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: ColorPalette.subTextColor,
      ),
    ),
  ),
);
