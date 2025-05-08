import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
// Importa o pacote principal do Flutter para usar widgets e temas.

class AppTheme {
  // Define uma classe estática para centralizar o tema do aplicativo.

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Define o tema como escuro
    primaryColor: ColorPalette.branco, // Cor principal
    scaffoldBackgroundColor: ColorPalette.branco, // Cor de fundo do Scaffold
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorPalette.preto), // Texto com cor branca
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.lightbutton,
        foregroundColor: ColorPalette.preto, // Cor do texto do botão
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: ColorPalette.preto,
      ), // Cor do label ("Usuário", "Senha")
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.preto),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.lightbutton),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Define o tema como escuro
    primaryColor: ColorPalette.dark, // Cor principal
    scaffoldBackgroundColor: ColorPalette.dark, // Cor de fundo do Scaffold
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorPalette.branco), // Texto com cor branca
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
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.branco),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.darkbutton),
      ),
    ),
  );
}
