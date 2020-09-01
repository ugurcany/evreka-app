// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evcontainer.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension EvContainerCopyWithExtension on EvContainer {
  EvContainer copyWith({
    double fullness,
    String id,
    LatLng latLng,
    DateTime nextCollection,
  }) {
    return EvContainer(
      fullness: fullness ?? this.fullness,
      id: id ?? this.id,
      latLng: latLng ?? this.latLng,
      nextCollection: nextCollection ?? this.nextCollection,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvContainer _$EvContainerFromJson(Map<String, dynamic> json) {
  return EvContainer(
    id: json['id'] as String,
    latLng: json['latLng'] == null
        ? null
        : LatLng.fromJson(json['latLng'] as Map<String, dynamic>),
    fullness: (json['fullness'] as num)?.toDouble(),
    nextCollection: json['nextCollection'] == null
        ? null
        : DateTime.parse(json['nextCollection'] as String),
  );
}

Map<String, dynamic> _$EvContainerToJson(EvContainer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('fullness', instance.fullness);
  writeNotNull('nextCollection', instance.nextCollection?.toIso8601String());
  return val;
}
