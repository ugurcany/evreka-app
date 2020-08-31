import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/feature/main/main_page.dart';
import 'package:presentation/src/feature/settings/settings_page.dart';
import 'package:presentation/src/feature/splash/splash_page.dart';

class Navigation {
  static const _SPLASH_ROUTE = "/";
  static const _MAIN_ROUTE = "/main";
  static const _SETTINGS_ROUTE = "/settings";

  static final _router = Router();

  init() {
    _router.define(
      _SPLASH_ROUTE,
      handler: Handler(handlerFunc: (context, params) => SplashPage()),
      transitionType: TransitionType.cupertino,
    );
    _router.define(
      _MAIN_ROUTE,
      handler: Handler(handlerFunc: (context, params) => MainPage()),
      transitionType: TransitionType.cupertino,
    );
    _router.define(
      _SETTINGS_ROUTE,
      handler: Handler(handlerFunc: (context, params) => SettingsPage()),
      transitionType: TransitionType.cupertino,
    );
  }

  Route<dynamic> Function(RouteSettings) generateRoutes() {
    return _router.generator;
  }

  static void navigateToSplash(BuildContext context) {
    _router.navigateTo(context, _SPLASH_ROUTE, clearStack: true);
  }

  static void navigateToMain(BuildContext context) {
    _router.navigateTo(context, _MAIN_ROUTE, replace: true);
  }

  static void navigateToSettings(BuildContext context) {
    _router.navigateTo(context, _SETTINGS_ROUTE);
  }

  static void pop(BuildContext context, {dynamic data}) {
    Navigator.pop(context, data);
  }
}
