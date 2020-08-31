import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';

class DialogBody extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String actionText;
  final Function onAction;

  DialogBody({
    @required this.title,
    @required this.children,
    @required this.actionText,
    @required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: _dialogContent(),
      actions: _dialogActions(context),
    );
  }

  Widget _dialogContent() {
    return Container(
      width: double.maxFinite,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: Dimens.UNIT),
        shrinkWrap: true,
        children: children,
      ),
    );
  }

  List<Widget> _dialogActions(BuildContext context) {
    return [
      FlatButton(
        child: Text(LocaleKeys.common_cancel.localized()),
        onPressed: () => Navigator.of(context).pop(),
      ),
      FlatButton(
        child: Text(actionText),
        onPressed: onAction,
      ),
    ];
  }
}
