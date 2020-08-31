import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class Style {
  static const PRIMARY_COLOR = Color(0xFF172C49);
  static const ACCENT_COLOR = Color(0xFF3BA935);
  static const LIGHT_GREY_COLOR = Color(0xFFECECEC);
  static const WHITE_COLOR = Color(0xFFFFFFFF);

  static get _primarySwatch {
    var colorMap = Map<int, Color>();
    List.generate(10, (i) {
      colorMap[i == 0 ? 50 : 100 * i] =
          PRIMARY_COLOR.withOpacity(0.1 * (i + 1));
    });
    return MaterialColor(PRIMARY_COLOR.value, colorMap);
  }

  static isThemeDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static saveThemeMode(BuildContext context, bool isDark) =>
      ThemeModeHandler.of(context)
          .saveThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

  Widget themedApp(Function(ThemeMode) appBuilder) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return ThemeModeHandler(
      manager: ThemeModeManager(),
      builder: appBuilder,
    );
  }

  ThemeData generateTheme(BuildContext context, {bool isDark = false}) {
    final theme = _createTheme(isDark: isDark);

    return theme.copyWith(
      textTheme: _createTextTheme(theme.textTheme),
      primaryTextTheme: _createTextTheme(theme.primaryTextTheme),
      accentTextTheme: _createTextTheme(theme.accentTextTheme),
    );
  }

  ThemeData _createTheme({@required bool isDark}) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primarySwatch: _primarySwatch,
      accentColor: ACCENT_COLOR,
      cursorColor: ACCENT_COLOR,
      textSelectionHandleColor: ACCENT_COLOR,
      toggleableActiveColor: ACCENT_COLOR,
    );
  }

  TextTheme _createTextTheme(TextTheme parent) {
    return GoogleFonts.openSansTextTheme(parent);
  }
}

class ThemeModeManager implements IThemeModeManager {
  static const _themeMode = "theme_mode";

  @override
  Future<String> loadThemeMode() async =>
      (await SharedPreferences.getInstance()).getString(_themeMode);

  @override
  Future<bool> saveThemeMode(String value) async =>
      (await SharedPreferences.getInstance()).setString(_themeMode, value);
}
