import 'dart:async';
import 'dart:developer';

import 'package:domain/domain.dart' hide LatLng;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/entity/evcontainer_ext.dart';
import 'package:presentation/src/widget/primary_button.dart';

class MapView extends StatefulWidget {
  final List<EvContainer> containers;
  final Function(double, double) onCameraIdle;

  MapView({
    this.containers,
    this.onCameraIdle,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = Completer<GoogleMapController>();
  BitmapDescriptor _batteryContainerPin;
  BitmapDescriptor _householdContainerPin;

  var _centerPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 13,
  );
  EvContainer _selectedContainer;

  @override
  void initState() {
    super.initState();
    _loadMarkerPins();
    _moveToCurrentPosition();
  }

  _loadMarkerPins() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.BATTERY_PIN,
    ).then((pin) {
      _batteryContainerPin = pin;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.HOUSEHOLD_PIN,
    ).then((pin) {
      _householdContainerPin = pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _map(context),
        Align(
          alignment: Alignment.topRight,
          child: _locateMeButton(context),
        ),
        AnimatedAlign(
          duration: kThemeAnimationDuration,
          alignment: Alignment(0, _selectedContainer != null ? 1 : 3),
          child: _infoCard(context),
        ),
      ],
    );
  }

  Widget _map(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      initialCameraPosition: _centerPosition,
      markers: _containersToMarkers(),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      onTap: (LatLng latLng) {
        setState(() => _selectedContainer = null);
      },
      onCameraMove: (CameraPosition position) {
        log("onCameraMove: " +
            position.target.latitude.toString() +
            ", " +
            position.target.longitude.toString());
        setState(() => _centerPosition = position);
      },
      onCameraIdle: () async {
        log("onCameraIdle");
        widget.onCameraIdle?.call(
          _centerPosition.target.latitude,
          _centerPosition.target.longitude,
        );
      },
    );
  }

  Widget _locateMeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.UNIT_4),
      child: FloatingActionButton(
        child: Icon(AppIcons.LOCATE_ME),
        onPressed: _moveToCurrentPosition,
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
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
                  .localized(args: [_selectedContainer?.id ?? "-"]),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimens.UNIT),
            Text(
              LocaleKeys.main_container_next_collection.localized(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              _selectedContainer?.displayNextCollection ?? "-",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: Dimens.UNIT),
            Text(
              LocaleKeys.main_container_fullness_rate.localized(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              _selectedContainer?.displaFullnessRate ?? "-",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: Dimens.UNIT_3),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_navigate.localized(),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: Dimens.UNIT_5),
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_relocate.localized(),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _moveToCurrentPosition() async {
    final Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    (await _mapController.future).animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 13,
        ),
      ),
    );
  }

  Set<Marker> _containersToMarkers() {
    return widget.containers?.map((container) {
          var icon;
          switch (container.type) {
            case EvContainerType.BATTERY:
              icon = _batteryContainerPin;
              break;
            case EvContainerType.HOUSEHOLD:
              icon = _householdContainerPin;
              break;
          }

          return Marker(
            markerId: MarkerId(container.id),
            position: LatLng(container.latLng.lat, container.latLng.lng),
            icon: icon,
            onTap: () => setState(() => _selectedContainer = container),
          );
        })?.toSet() ??
        null;
  }
}
