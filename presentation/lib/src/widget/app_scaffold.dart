import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/entity/action_item.dart';
import 'package:presentation/src/widget/app_logo.dart';
import 'package:presentation/src/widget/overflow_menu.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget bottomNavigationBar;
  final Widget drawer;
  final Widget action;
  final List<ActionItem> actionItems;

  AppScaffold({
    @required this.body,
    this.title,
    this.bottomNavigationBar,
    this.drawer,
    this.action,
    this.actionItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: drawer == null,
        title: title != null ? Text(title) : _appLogo(context),
        actions: _drawerOrAction(context),
        elevation: 0,
      ),
      endDrawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _appLogo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Style.WHITE_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.UNIT)),
      ),
      padding: EdgeInsets.all(Dimens.UNIT),
      child: AppLogo(height: 24),
    );
  }

  List<Widget> _drawerOrAction(BuildContext context) {
    if (drawer != null)
      return [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(AppIcons.DRAWER_MENU),
            tooltip: LocaleKeys.common_menu.localized(),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ];
    if (action != null)
      return [
        action,
      ];
    if (actionItems != null)
      return [
        OverflowMenu(
          offset: Offset(0, 50),
          actionItems: actionItems,
        ),
      ];
    return null;
  }
}
