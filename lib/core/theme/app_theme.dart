import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPalette.branco,
    textTheme: GoogleFonts.montserratTextTheme().apply(
      // Define a fonte global
      bodyColor: ColorPalette.preto, // Cor padrão do texto
      displayColor: ColorPalette.preto, // Cor padrão para textos maiores
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.montserrat(
          // Aplica a fonte nos botões
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorPalette.lightbutton,
        foregroundColor: ColorPalette.branco,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: ColorPalette.preto),
      hintStyle: TextStyle(color: ColorPalette.cinzaMedio),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.cinzaMaisClaro),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.lightbutton),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorPalette.branco,
    textTheme: GoogleFonts.montserratTextTheme().apply(
      // Define a fonte global
      bodyColor: ColorPalette.branco, // Cor padrão do texto
      displayColor: ColorPalette.branco, // Cor padrão para textos maiores
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.montserrat(
          // Altere para Montserrat
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorPalette.button,
        foregroundColor: ColorPalette.branco,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: ColorPalette.cinzaMedio), // Cor do label
      hintStyle: TextStyle(color: ColorPalette.cinzaMedio), // Cor do hint
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.cinzaMaisClaro),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.lightbutton),
      ),
      floatingLabelStyle: TextStyle(
        color: ColorPalette.button,
      ), // Cor do label flutuante
      counterStyle: TextStyle(
        color: ColorPalette.preto,
      ), // Cor do contador (se usado)
      helperStyle: TextStyle(
        color: ColorPalette.preto,
      ), // Cor do texto auxiliar
      errorStyle: TextStyle(color: Colors.red), // Cor do texto de erro
    ),
  );
}
