import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/feature/settings/settings_controller.dart';
import 'package:presentation/src/feature/ui_state.dart';
import 'package:presentation/src/widget/app_scaffold.dart';
import 'package:presentation/src/widget/section_title.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends UiState<SettingsPage, SettingsController> {
  final _controller = SettingsController();

  @override
  SettingsController get controller => _controller;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: LocaleKeys.settings_title.localized(),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimens.UNIT_4),
      children: [
        SectionTitle(title: LocaleKeys.settings_app_settings.localized()),
        _darkModeItem(context),
        Divider(),
        _languageItem(context),
        Divider(),
      ],
    );
  }

  Widget _darkModeItem(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.SETTINGS_DARK_MODE),
      title: Text(LocaleKeys.settings_dark_mode.localized()),
      trailing: Switch(
        value: Style.isThemeDark(context),
        onChanged: (isDark) => Style.saveThemeMode(context, isDark),
      ),
    );
  }

  Widget _languageItem(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.SETTINGS_LANGUAGE),
      title: Text(LocaleKeys.settings_language.localized()),
      trailing: DropdownButton(
        underline: const SizedBox(),
        value: Localization.getCurrentLocaleWrapper(context),
        items: Localization.localeWrappers
            .map((lw) => DropdownMenuItem(
                  value: lw,
                  child: Text(lw.displayTitle),
                ))
            .toList(),
        onChanged: (lw) => Localization.setLocale(context, lw),
      ),
    );
  }
}
