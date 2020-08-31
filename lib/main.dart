import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';

void main() {
  //RECORD ERRORS ON CRASHLYTICS
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  //INIT MODULES
  Data.init();
  Domain.init();
  Presentation.init();
  //RUN APP
  runApp(EvrekaApp());
}

class EvrekaApp extends StatelessWidget {
  final _navigation = Navigation();
  final _style = Style();
  final _localization = Localization();
  final _analytics = FirebaseAnalytics();

  EvrekaApp() {
    _navigation.init();
  }

  @override
  Widget build(BuildContext context) {
    return _localization.localizedApp(
      (context) => _style.themedApp(
        (themeMode) => MaterialApp(
          title: "evreka",
          themeMode: themeMode,
          theme: _style.generateTheme(context),
          darkTheme: _style.generateTheme(context, isDark: true),
          onGenerateRoute: _navigation.generateRoutes(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: _analytics),
          ],
          localizationsDelegates: _localization.delegates(context),
          supportedLocales: _localization.supportedLocales(context),
          locale: _localization.locale(context),
        ),
      ),
    );
  }
}
