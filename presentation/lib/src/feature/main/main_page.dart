import 'package:flutter/material.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/feature/main/main_controller.dart';
import 'package:presentation/src/feature/main/widget/drawer_item.dart';
import 'package:presentation/src/feature/main/widget/main_drawer.dart';
import 'package:presentation/src/feature/main/widget/user_drawer_header.dart';
import 'package:presentation/src/feature/ui_state.dart';
import 'package:presentation/src/widget/app_scaffold.dart';
import 'package:presentation/src/widget/dialog/yes_no_dialog.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends UiState<MainPage, MainController> {
  final _controller = MainController();

  @override
  MainController get controller => _controller;

  @override
  void initState() {
    super.initState();
    controller.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _content(context),
      drawer: _drawer(),
    );
  }

  Widget _content(BuildContext context) {
    return Container();
  }

  Widget _drawer() {
    return MainDrawer(
      children: [
        UserDrawerHeader(user: controller.data.user),
        Expanded(child: const SizedBox()),
        DrawerItem(
          icon: AppIcons.SETTINGS,
          title: LocaleKeys.main_settings.localized(),
          onTap: () => controller.onSettingsClicked(),
        ),
        Divider(),
        DrawerItem(
          icon: AppIcons.LOGOUT,
          title: LocaleKeys.main_logout.localized(),
          onTap: () => showYesNoDialog(
            context,
            title: LocaleKeys.main_logout.localized(),
            message: LocaleKeys.main_logout_message.localized(),
            actionText: LocaleKeys.main_logout.localized(),
            onAction: () => controller.onLogoutClicked(),
          ),
        ),
        const SizedBox(height: Dimens.UNIT_4),
      ],
    );
  }
}
