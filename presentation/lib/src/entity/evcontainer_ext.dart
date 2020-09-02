import 'package:domain/domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';

extension EvContainerExt on EvContainer {
  String get displayNextCollection =>
      DateFormat("dd.MM.yyyy").format(nextCollection);

  String get displayFullnessRate => "${(fullness * 100).toInt()}%";

  String get displayTemperature => "${temperature.toStringAsFixed(1)}\u2103";

  String get displayType {
    switch (type) {
      case EvContainerType.BATTERY:
        return LocaleKeys.main_container_type_battery.localized();
      case EvContainerType.HOUSEHOLD:
        return LocaleKeys.main_container_type_household.localized();
      default:
        return "?";
    }
  }
}
