import 'package:flutter/material.dart';

class Apptheme {
  static const Color primaryBackground = Color(0xFFF5EFD2);
  static const Color accentDark = Color(0xFF4D0C0C);      
  static const Color black = Color(0xFF000000);
  static const Color greyText = Color(0xFF757575);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: primaryBackground,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBackground,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        fontFamily: 'Serif', 
        fontSize: 22,
        color: black,
      ),
    ),

    textTheme: const TextTheme(
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: black),
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: black),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: black), // Added this
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: black),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: black),
      bodyLarge: TextStyle(fontSize: 16, color: black),
      bodyMedium: TextStyle(fontSize: 14, color: black),
      bodySmall: TextStyle(fontSize: 12, color: greyText),
    ),
  );
  static TextTheme get textTheme => lightTheme.textTheme;
}