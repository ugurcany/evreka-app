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
    double temperature,
    EvContainerType type,
  }) {
    return EvContainer(
      fullness: fullness ?? this.fullness,
      id: id ?? this.id,
      latLng: latLng ?? this.latLng,
      nextCollection: nextCollection ?? this.nextCollection,
      temperature: temperature ?? this.temperature,
      type: type ?? this.type,
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
    temperature: (json['temperature'] as num)?.toDouble(),
    nextCollection: json['nextCollection'] == null
        ? null
        : DateTime.parse(json['nextCollection'] as String),
    type: _$enumDecodeNullable(_$EvContainerTypeEnumMap, json['type']),
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
  writeNotNull('temperature', instance.temperature);
  writeNotNull('nextCollection', instance.nextCollection?.toIso8601String());
  writeNotNull('type', _$EvContainerTypeEnumMap[instance.type]);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EvContainerTypeEnumMap = {
  EvContainerType.BATTERY: 'BATTERY',
  EvContainerType.HOUSEHOLD: 'HOUSEHOLD',
};
