import 'package:domain/domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';

class Localization {
  static List<LocaleWrapper> get localeWrappers => [
        LocaleWrapper(locale: Locale('en'), displayTitle: "English"),
        LocaleWrapper(locale: Locale('tr'), displayTitle: "Türkçe"),
      ];

  static LocaleWrapper getCurrentLocaleWrapper(BuildContext context) {
    return localeWrappers
        .firstWhere((lw) => lw.locale == EasyLocalization.of(context).locale);
  }

  static String getCurrentLanguageCode(BuildContext context) {
    return EasyLocalization.of(context).locale.languageCode;
  }

  static setLocale(BuildContext context, LocaleWrapper lw) {
    EasyLocalization.of(context).locale = lw.locale;
  }

  Widget localizedApp(WidgetBuilder appBuilder) {
    return EasyLocalization(
      child: Builder(builder: appBuilder),
      preloaderColor: Style.WHITE_COLOR,
      useOnlyLangCode: true,
      supportedLocales: localeWrappers.map((lw) => lw.locale).toList(),
      fallbackLocale: localeWrappers[0].locale,
      path: "assets/strings",
    );
  }

  List<LocalizationsDelegate> delegates(BuildContext context) {
    return EasyLocalization.of(context).delegates;
  }

  List<Locale> supportedLocales(BuildContext context) {
    return EasyLocalization.of(context).supportedLocales;
  }

  Locale locale(BuildContext context) {
    return EasyLocalization.of(context).locale;
  }
}

extension LocalizationExt on String {
  String localized({List<String> args}) => this.tr(args: args);
}

class LocaleWrapper extends Equatable {
  final Locale locale;
  final String displayTitle;

  LocaleWrapper({
    this.locale,
    this.displayTitle,
  });

  @override
  List<Object> get props => [locale];

  @override
  bool get stringify => true;
}
