import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/entity/evcontainer_ext.dart';
import 'package:presentation/src/widget/primary_button.dart';
import 'package:presentation/src/widget/toaster.dart';

class ContainerInfoCard extends StatelessWidget {
  final EvContainer container;
  final Function onRelocateClicked;

  ContainerInfoCard({
    this.container,
    this.onRelocateClicked,
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
              LocaleKeys.main_container_id
                  .localized(args: [container?.id ?? "-"]),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimens.UNIT_2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.main_container_next_collection.localized(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                Expanded(
                  child: Text(
                    LocaleKeys.main_container_type.localized(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    container?.displayNextCollection ?? "-",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    container?.displayType ?? "-",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.UNIT_2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.main_container_fullness_rate.localized(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                Expanded(
                  child: Text(
                    LocaleKeys.main_container_temperature.localized(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    container?.displayFullnessRate ?? "-",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    container?.displayTemperature ?? "-",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.UNIT_4),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_navigate.localized(),
                    onPressed: () => _startNavigation(context),
                  ),
                ),
                const SizedBox(width: Dimens.UNIT_5),
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_relocate.localized(),
                    onPressed: () => onRelocateClicked?.call(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _startNavigation(BuildContext context) async {
    double lat = container.latLng.lat;
    double lng = container.latLng.lng;

    final url = "https://www.google.com/maps/dir/?api=1" +
        "&travelmode=driving" +
        "&dir_action=navigate" +
        "&destination=$lat,$lng";

    if (await canLaunch(url))
      await launch(url);
    else
      Toaster.show(
          context, LocaleKeys.main_container_navigate_error.localized());
  }
}
