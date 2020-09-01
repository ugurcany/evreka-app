import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:domain/src/entity/latlng.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'evcontainer.g.dart';

@CopyWith()
@JsonSerializable(nullable: true, explicitToJson: true, includeIfNull: false)
class EvContainer extends Equatable {
  final String id;
  final LatLng latLng;
  final double fullness;
  final DateTime nextCollection;

  EvContainer({
    this.id,
    this.latLng,
    this.fullness,
    this.nextCollection,
  });

  @override
  List<Object> get props => [
        id,
        latLng,
        fullness,
        nextCollection,
      ];

  @override
  bool get stringify => true;

  factory EvContainer.fromJson(Map<String, dynamic> json) =>
      _$EvContainerFromJson(json);

  Map<String, dynamic> toJson() => _$EvContainerToJson(this);
}
