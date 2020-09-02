import 'dart:async';
import 'dart:developer';

import 'package:domain/domain.dart' hide LatLng;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/feature/main/widget/container_info_card.dart';
import 'package:presentation/src/feature/main/widget/relocation_card.dart';
import 'package:presentation/src/widget/toaster.dart';

const double MAX_ZOOM = 18;
const double MIN_ZOOM = 10;

class MapView extends StatefulWidget {
  final List<EvContainer> containers;
  final Function(double, double, double) onCameraIdle;
  final Function(String, double, double) onRelocate;

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
  String _selectedContainerId;
  LatLng _relocationPoint;
  bool _isRelocating = false;

  EvContainer get _selectedContainer => widget.containers
      ?.singleWhere((c) => c.id == _selectedContainerId, orElse: () => null);

  double get _geoRadius => (MAX_ZOOM - _centerPosition.zoom + MIN_ZOOM);

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
          child: ContainerInfoCard(
            container: _selectedContainer,
            onRelocateClicked: () => _enableRelocation(),
          ),
        ),
        AnimatedAlign(
          duration: kThemeAnimationDuration,
          alignment: Alignment(0, _isRelocating ? 1 : 3),
          child: RelocationCard(
            onCancel: () => _resetView(),
            onSave: () => _saveRelocation(),
          ),
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
      minMaxZoomPreference: MinMaxZoomPreference(MIN_ZOOM, MAX_ZOOM),
      markers: _containersToMarkers(),
      circles: _generateCenterCircle(),
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
          _geoRadius,
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

  _resetView() {
    setState(() {
      _selectedContainerId = null;
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
        _selectedContainerId,
        _relocationPoint.latitude,
        _relocationPoint.longitude,
      );
      _resetView();
    }
  }

  _showInfoCard(String selectedContainerId) {
    setState(() {
      _isRelocating = false;
      _relocationPoint = null;
      _selectedContainerId = selectedContainerId;
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

  Set<Circle> _generateCenterCircle() {
    return Set.from([
      Circle(
        circleId: CircleId("center_circle"),
        center: LatLng(
          _centerPosition.target.latitude,
          _centerPosition.target.longitude,
        ),
        radius: _geoRadius * 1000,
        strokeColor: Theme.of(context).primaryColor.withOpacity(0.2),
      )
    ]);
  }

  Marker _generateMarker(EvContainer container) {
    return Marker(
      markerId: MarkerId(container.id),
      position: LatLng(container.latLng.lat, container.latLng.lng),
      icon: _getMarkerPin(container.type),
      onTap: () => _showInfoCard(container.id),
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
