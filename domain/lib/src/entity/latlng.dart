import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'latlng.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true, includeIfNull: false)
class LatLng extends Equatable {
  final double lat;
  final double lng;

  LatLng(
    this.lat,
    this.lng,
  );

  @override
  List<Object> get props => [
        lat,
        lng,
      ];

  @override
  bool get stringify => true;

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);

  Map<String, dynamic> toJson() => _$LatLngToJson(this);
}
