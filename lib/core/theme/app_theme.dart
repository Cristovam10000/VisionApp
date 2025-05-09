import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// Importa o pacote principal do Flutter para usar widgets e temas.

class AppTheme {
  // Define uma classe estática para centralizar o tema do aplicativo.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPalette.branco,
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      bodyLarge: const TextStyle(color: ColorPalette.branco),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
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
    brightness: Brightness.dark, // Define o tema como escuro
    primaryColor: ColorPalette.dark, // Cor principal
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      bodyLarge: const TextStyle(color: ColorPalette.branco),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.darkbutton,
        foregroundColor: ColorPalette.branco,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: ColorPalette.branco,
      ), // Cor do label ("Usuário", "Senha")
      hintStyle: TextStyle(
        color: ColorPalette.cinzaMedio, // Cor do texto de dica (hint)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.branco),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.darkbutton),
      ),
    ),
  );
}
