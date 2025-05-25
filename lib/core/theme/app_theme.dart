import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorPalette.branco,

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return ColorPalette.lightbutton; // cor ao pressionar
            }
            return ColorPalette.branco; // cor padrão
          },
        ),
      ),
    ),

    // Texto com fonte Montserrat e pesos personalizados
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: ColorPalette.branco,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ColorPalette.branco,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: ColorPalette.branco,
      ),
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ColorPalette.branco,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorPalette.branco,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ColorPalette.branco,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ColorPalette.branco,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorPalette.preto,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ColorPalette.branco,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ColorPalette.branco,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorPalette.preto,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: ColorPalette.branco,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ColorPalette.branco,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ColorPalette.branco,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: ColorPalette.branco,
      ),
    ),

    // Botões elevados com fonte personalizada
    elevatedButtonTheme: ElevatedButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStateProperty.all(
      GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return ColorPalette.darkbutton; // cor quando pressionado
      }
      return ColorPalette.button; // cor normal
    }),
    foregroundColor: WidgetStateProperty.all(ColorPalette.branco),
  ),
),

    // Input fields com fonte personalizada
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.montserrat(color: ColorPalette.cinzaMedio),
      hintStyle: GoogleFonts.montserrat(color: ColorPalette.cinzaMedio),
      floatingLabelStyle: GoogleFonts.montserrat(color: ColorPalette.button),
      counterStyle: GoogleFonts.montserrat(color: ColorPalette.preto),
      helperStyle: GoogleFonts.montserrat(color: ColorPalette.preto),
      errorStyle: GoogleFonts.montserrat(color: Colors.red),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.cinzaMaisClaro),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.lightbutton),
      ),
    ),
  );
}
