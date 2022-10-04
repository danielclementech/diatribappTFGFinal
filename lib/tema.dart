// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
const kThemeModeKey = '__theme_mode__';
SharedPreferences _prefs;

 */

abstract class Tema {
  /*
  static Future initialize() async =>
  _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
  final darkMode = _prefs?.getBool(kThemeModeKey);
  return darkMode == null
  ? ThemeMode.system
      : darkMode
  ? ThemeMode.dark
      : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
  ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) =>
  Theme.of(context).brightness == Brightness.dark
  ? DarkModeTheme()
      : LightModeTheme();

   */

  static Tema of(BuildContext context) => LightModeTheme();

  late Color primaryColor;
  late Color secondaryColor;
  late Color white;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;
  late Color buttonColor;
  late Color textButtonColor;
  late Color spotifyColor;
  late Color softBlue;
  late Color turquesa;
  late Color darkGreen;

  late Color customColor1;
  late Color customColor2;
  late Color customColor3;

  TextStyle get title1 => GoogleFonts.getFont(
        'Montserrat',
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      );
  TextStyle get title2 => GoogleFonts.getFont(
        'Nunito',
        color: white,
        fontWeight: FontWeight.w500,
        fontSize: 22,
      );
  TextStyle get title3 => GoogleFonts.getFont(
        'Nunito',
        color: primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Nunito',
        color: primaryColor,
        fontWeight: FontWeight.w900,
        fontSize: 18,
      );
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Montserrat',
        color: secondaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  TextStyle get subtitle3 => GoogleFonts.getFont(
        'Montserrat',
        color: darkGreen,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Nunito',
        color: primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Nunito',
        color: turquesa,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  TextStyle get secondaryText1 => GoogleFonts.getFont(
        'Nunito',
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  TextStyle get appBarText => GoogleFonts.getFont(
        'Nunito',
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      );
}

class LightModeTheme extends Tema {
  Color primaryColor = const Color(0xFF0D2149);
  Color secondaryColor = const Color(0xFF17C08E);
  Color white = const Color(0xFFFFFFFF);
  Color alternate = const Color(0xFF1FC0C6);
  Color softBlue = const Color(0xFF208AAE);
  Color turquesa = const Color(0xFFBDEDE0);
  Color darkGreen = const Color(0xFF093824);
  Color textButtonColor = const Color(0xFFFFFFFF);
  Color primaryBackground = const Color(0xFFF1F4F8);
  Color secondaryBackground = const Color(0xFF0D2149);
  Color primaryText = const Color(0x00000000);
  Color secondaryText = const Color(0xFF706C6C);
  Color spotifyColor = const Color(0xFF1DB954);

  Color customColor1 = Color(0xFF281BB4);
  Color customColor2 = Color(0xFFC1529E);
  Color customColor3 = Color(0xFFD6DE75);
}

/*
class DarkModeTheme extends FlutterFlowTheme {
  Color primaryColor = const Color(0xFF1A115C);
  Color secondaryColor = const Color(0xFF1FC0C6);
  Color tertiaryColor = const Color(0xFFF0F0F0);
  Color alternate = const Color(0xFF1FC0C6);
  Color primaryBackground = const Color(0xFF1A115C);
  Color secondaryBackground = const Color(0xFF1A115C);
  Color primaryText = const Color(0x00000000);
  Color secondaryText = const Color(0x00000000);

  Color customColor1 = Color(0xFF281BB4);
  Color customColor2 = Color(0xFFC1529E);
  Color customColor3 = Color(0xFFD6DE75);
}

 */

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              height: lineHeight,
            );
}
