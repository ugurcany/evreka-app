import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/widget/avatar.dart';

class UserDrawerHeader extends StatelessWidget {
  final User user;

  UserDrawerHeader({
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      padding: EdgeInsets.all(Dimens.UNIT_4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            url: user?.avatarUrl ?? "",
            radius: 30,
          ),
          const SizedBox(width: Dimens.UNIT_4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? "",
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
                const SizedBox(height: Dimens.UNIT),
                Text(
                  user?.email ?? "",
                  style: Theme.of(context).primaryTextTheme.subtitle2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
