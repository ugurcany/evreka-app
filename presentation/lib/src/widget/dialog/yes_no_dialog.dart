import 'package:flutter/material.dart';
import 'package:presentation/src/widget/dialog/dialog_body.dart';

showYesNoDialog(
  BuildContext context, {
  @required String title,
  @required String message,
  @required String actionText,
  Function onAction,
}) async {
  //SHOW YES NO DIALOG
  var input = await showDialog(
    context: context,
    builder: (context) => _YesNoDialog(
      title: title,
      message: message,
      actionText: actionText,
    ),
  );

  //TRIGGER CALLBACK FUNCTION
  if (input != null) onAction?.call();
}

class _YesNoDialog extends StatefulWidget {
  final String title;
  final String message;
  final String actionText;

  _YesNoDialog({
    @required this.title,
    @required this.message,
    @required this.actionText,
  });

  @override
  _YesNoDialogState createState() => _YesNoDialogState();
}

class _YesNoDialogState extends State<_YesNoDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogBody(
      title: widget.title,
      children: [Text(widget.message)],
      actionText: widget.actionText,
      onAction: () => Navigator.of(context).pop(true),
    );
  }
}
