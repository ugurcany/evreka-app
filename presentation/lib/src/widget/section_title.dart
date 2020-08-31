import 'package:flutter/material.dart';
import 'package:presentation/src/core/resources.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  SectionTitle({
    @required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: Dimens.UNIT_2),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(child: const SizedBox()),
        ]..addAll(actions ?? const []),
      ),
    );
  }
}
