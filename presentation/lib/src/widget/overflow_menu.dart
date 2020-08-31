import 'package:flutter/material.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/entity/action_item.dart';

class OverflowMenu extends StatelessWidget {
  final List<ActionItem> actionItems;
  final Widget child;
  final Offset offset;
  final String tooltip;

  OverflowMenu({
    @required this.actionItems,
    this.child,
    this.offset = const Offset(0, 0),
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return (actionItems?.isNotEmpty ?? false)
        ? PopupMenuButton<ActionItem>(
            offset: offset,
            tooltip: tooltip,
            icon: child == null ? Icon(AppIcons.OVERFLOW_MENU) : null,
            child: child,
            itemBuilder: (context) {
              return actionItems
                  .where((actionItem) => actionItem.isVisible)
                  .map((actionItem) => PopupMenuItem<ActionItem>(
                        value: actionItem,
                        child: _item(context, actionItem),
                      ))
                  .toList();
            },
            onSelected: (menuAction) => menuAction.onPressed?.call(),
          )
        : child;
  }

  Widget _item(BuildContext context, ActionItem actionItem) {
    return Row(
      children: <Widget>[
        Icon(
          actionItem.icon,
          size: Dimens.UNIT_5,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: Dimens.UNIT_2),
        Text(actionItem.title),
      ],
    );
  }
}
