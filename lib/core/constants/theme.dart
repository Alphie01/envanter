import 'package:flutter/material.dart';

class AppTheme {

  
  static bool dataSaverMode = false;


  AppTheme._();
  static Color nearlyWhite = Color(0xFFFAFAFA);
  static Color white = Color(0xFFFFFFFF);
  //light Theme
  static Color textColor = HexColor('#121712');
  static Color background = HexColor('#DCE0E5');
  //dark theme
  static Color background1 = HexColor('#EFF1F3');
  static Color background2 = HexColor('#ffffff');

  static Color firstColor = HexColor('#805FF8');
  static Color contrastColor1 = HexColor('#896BF9');
  static Color contrastColor2 = HexColor('#9276F9');
  static Color contrastColor3 = HexColor('#AA94FB');
  static Color contrastColor4 = HexColor('#C1B1FC');

  static Color nearlydarkPurple = HexColor('#270722');
  static Color crimson = HexColor('#911F31');
  static Color darkPurple = HexColor('#1D0F1A');
  static Color allowedGreen = HexColor('#2ecc71');
  static List<Color> alertRed = [HexColor('#FC5050'), background];
  static List<Color> alertYellow = [HexColor('#f6b258'), textColor];
  static List<Color> alertGreen = [HexColor('#28AFB0'), textColor];
  static AssetImage logo = AssetImage('assets/logo_dark.png');

  static void setDarkTheme() {
    textColor = AppBlackTheme.textColor;
    background = AppBlackTheme.background;
    background1 = AppBlackTheme.background1;
    background2 = AppBlackTheme.background2;
    logo = AssetImage('assets/logo.png');
  }

  static void contrastColorInitilizer() {
    textColor = AppBlackTheme.textColor;
    background = AppBlackTheme.background;
    background1 = AppBlackTheme.background1;
    background2 = AppBlackTheme.background2;
  }

  static void setBrightTheme() {
    textColor = HexColor('#121712');
    background = HexColor('#DCE0E5');
    background1 = HexColor('#EFF1F3');
    background2 = HexColor('#ffffff');
    logo = AssetImage('assets/logo_dark.png');
  }
}

class AppBlackTheme {
  AppBlackTheme._();
  static Color nearlyWhite = Color(0xFFFAFAFA);
  static Color white = Color(0xFFFFFFFF);
  //light Theme
  static Color textColor = HexColor('#DCE0E5');
  static Color background = HexColor('#14141D');

  //dark theme
  static Color background1 = HexColor('#272733');
  static Color background2 = HexColor('#343440');

  static Color homeContainer = HexColor('#19191f');

  static Color firstColor = HexColor('#805FF8');
  static Color contrastColor1 = HexColor('#896BF9');
  static Color contrastColor2 = HexColor('#9276F9');
  static Color contrastColor3 = HexColor('#AA94FB');
  static Color contrastColor4 = HexColor('#C1B1FC');

  static Color nearlydarkPurple = HexColor('#270722');
  static Color crimson = HexColor('#911F31');
  static Color darkPurple = HexColor('#1D0F1A');
  static Color allowedGreen = HexColor('#2ecc71').withOpacity(.3);
  static List<Color> alertRed = [HexColor('#FC5050'), background];
  static List<Color> alertYellow = [HexColor('#F6D958'), textColor];
  static List<Color> alertGreen = [HexColor('#28AFB0'), textColor];
}

Duration defaultDuration = Duration(milliseconds: 400);

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
