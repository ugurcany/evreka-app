import 'package:flutter/material.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';

class RelocationSuccessCard extends StatelessWidget {
  RelocationSuccessCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Dimens.UNIT_4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.UNIT_2),
      ),
      margin: EdgeInsets.symmetric(
        vertical: Dimens.UNIT_6,
        horizontal: Dimens.UNIT_3,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.UNIT_5,
          vertical: Dimens.UNIT_9,
        ),
        width: double.infinity,
        child: Text(
          LocaleKeys.main_container_relocate_success.localized(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
