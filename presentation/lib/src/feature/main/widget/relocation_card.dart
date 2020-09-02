import 'package:flutter/material.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/widget/primary_button.dart';

class RelocationCard extends StatelessWidget {
  final Function onCancel;
  final Function onSave;

  RelocationCard({
    this.onCancel,
    this.onSave,
  });

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
        padding: EdgeInsets.all(Dimens.UNIT_5),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.main_container_relocate_description.localized(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: Dimens.UNIT_4),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.common_cancel.localized(),
                    onPressed: () => onCancel(),
                  ),
                ),
                const SizedBox(width: Dimens.UNIT_5),
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_save.localized(),
                    onPressed: () => onSave(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
