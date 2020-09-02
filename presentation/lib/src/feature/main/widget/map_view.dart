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
import 'package:presentation/src/widget/toaster.dart';

class MapView extends StatefulWidget {
  final List<EvContainer> containers;
  final Function(double, double) onCameraIdle;
  final Function(EvContainer, double, double) onRelocate;

  MapView({
    this.containers,
    this.onCameraIdle,
    this.onRelocate,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = Completer<GoogleMapController>();
  BitmapDescriptor _batteryContainerPin;
  BitmapDescriptor _householdContainerPin;
  BitmapDescriptor _batteryContainerRelocatedPin;
  BitmapDescriptor _householdContainerRelocatedPin;

  CameraPosition _centerPosition = CameraPosition(target: LatLng(0, 0));
  EvContainer _selectedContainer;
  LatLng _relocationPoint;
  bool _isRelocating = false;

  @override
  void initState() {
    super.initState();
    _loadMarkerPins();
    _moveToCurrentPosition();
  }

  _loadMarkerPins() {
    //LOAD BATTERY PINS
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.BATTERY_PIN,
    ).then((pin) {
      _batteryContainerPin = pin;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.BATTERY_RELOCATED_PIN,
    ).then((pin) {
      _batteryContainerRelocatedPin = pin;
    });
    //LOAD HOUSEHOLD PINS
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.HOUSEHOLD_PIN,
    ).then((pin) {
      _householdContainerPin = pin;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.HOUSEHOLD_RELOCATED_PIN,
    ).then((pin) {
      _householdContainerRelocatedPin = pin;
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
          alignment: Alignment(
              0, (_selectedContainer != null && !_isRelocating) ? 1 : 3),
          child: _infoCard(context),
        ),
        AnimatedAlign(
          duration: kThemeAnimationDuration,
          alignment: Alignment(0, _isRelocating ? 1 : 3),
          child: _relocationCard(context),
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
        if (_isRelocating)
          setState(() {
            _relocationPoint = latLng;
          });
        else
          _resetView();
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
                    _selectedContainer?.displayNextCollection ?? "-",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    _selectedContainer?.displayType ?? "-",
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
                    _selectedContainer?.displayFullnessRate ?? "-",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    _selectedContainer?.displayTemperature ?? "-",
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
                    onPressed: () => Toaster.show(
                        context, LocaleKeys.common_not_implemented.localized()),
                  ),
                ),
                const SizedBox(width: Dimens.UNIT_5),
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_relocate.localized(),
                    onPressed: () => _enableRelocation(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _relocationCard(BuildContext context) {
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
                    onPressed: () => _resetView(),
                  ),
                ),
                const SizedBox(width: Dimens.UNIT_5),
                Expanded(
                  child: PrimaryButton(
                    text: LocaleKeys.main_container_save.localized(),
                    onPressed: () => _saveRelocation(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _resetView() {
    setState(() {
      _selectedContainer = null;
      _isRelocating = false;
      _relocationPoint = null;
    });
  }

  _enableRelocation() {
    setState(() => _isRelocating = true);
  }

  _saveRelocation() {
    if (_relocationPoint == null)
      Toaster.show(
          context, LocaleKeys.main_container_relocate_warning.localized());
    else {
      widget.onRelocate?.call(
        _selectedContainer,
        _relocationPoint.latitude,
        _relocationPoint.longitude,
      );
      _resetView();
    }
  }

  _showInfoCard(EvContainer selectedContainer) {
    setState(() {
      _isRelocating = false;
      _relocationPoint = null;
      _selectedContainer = selectedContainer;
    });
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
    //SHOW ONLY SELECTED CONTAINER (AND RELOCATION POINT IF ANY)
    if (_isRelocating) {
      final markerSet = Set<Marker>();
      markerSet.add(_generateMarker(_selectedContainer));

      if (_relocationPoint != null) {
        markerSet.add(
          Marker(
            markerId: MarkerId("${_selectedContainer.id}_relocated"),
            position:
                LatLng(_relocationPoint.latitude, _relocationPoint.longitude),
            icon: _getMarkerPin(_selectedContainer.type, isRelocated: true),
          ),
        );
      }
      return markerSet;
    }
    //SHOW ALL CONTAINERS
    return widget.containers
            ?.map((container) => _generateMarker(container))
            ?.toSet() ??
        null;
  }

  Marker _generateMarker(EvContainer container) {
    return Marker(
      markerId: MarkerId(container.id),
      position: LatLng(container.latLng.lat, container.latLng.lng),
      icon: _getMarkerPin(container.type),
      onTap: () => _showInfoCard(container),
    );
  }

  BitmapDescriptor _getMarkerPin(
    EvContainerType containerType, {
    bool isRelocated = false,
  }) {
    var pin;
    switch (containerType) {
      case EvContainerType.BATTERY:
        pin =
            isRelocated ? _batteryContainerRelocatedPin : _batteryContainerPin;
        break;
      case EvContainerType.HOUSEHOLD:
        pin = isRelocated
            ? _householdContainerRelocatedPin
            : _householdContainerPin;
        break;
    }
    return pin;
  }
}
