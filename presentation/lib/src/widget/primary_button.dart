import 'package:flutter/material.dart';
import 'package:presentation/src/core/resources.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  PrimaryButton({
    @required this.text,
    @required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: _text(context),
      padding: _padding(),
      shape: _border(context),
      color: Theme.of(context).accentColor,
      onPressed: onPressed,
    );
  }

  Widget _text(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: _style(context),
    );
  }

  EdgeInsets _padding() {
    return EdgeInsets.symmetric(
      horizontal: Dimens.UNIT_8,
      vertical: Dimens.UNIT_2,
    );
  }

  ShapeBorder _border(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.UNIT),
    );
  }

  TextStyle _style(BuildContext context) =>
      Theme.of(context).primaryTextTheme.headline6.copyWith(
            fontWeight: FontWeight.bold,
          );
}
