import 'package:domain/domain.dart';
import 'package:easy_localization/easy_localization.dart';

extension EvContainerExt on EvContainer {
  String get displayNextCollection =>
      DateFormat("dd.MM.yyyy").format(nextCollection);

  String get displaFullnessRate => "${(fullness * 100).toInt()}%";
}
