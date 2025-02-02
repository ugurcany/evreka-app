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
import 'package:presentation/src/feature/main/widget/relocation_success_card.dart';
import 'package:presentation/src/widget/toaster.dart';

/*
  MARKER CLUSTERS NOT SUPPORTED YET: https://github.com/flutter/flutter/issues/26863
*/

const double MAX_ZOOM = 18;
const double MIN_ZOOM = 10;

class MapView extends StatefulWidget {
  final List<EvContainer> containers;
  final Function(double, double, double) onCameraIdle;
  final Function(String, double, double) onRelocate;
  final bool isRelocationSuccessful;

  MapView({
    this.containers,
    this.onCameraIdle,
    this.onRelocate,
    this.isRelocationSuccessful,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  final _mapController = Completer<GoogleMapController>();
  BitmapDescriptor _batteryContainerPin;
  BitmapDescriptor _householdContainerPin;

  CameraPosition _centerPosition = CameraPosition(target: LatLng(0, 0));
  EvContainer _selectedContainer;
  LatLng _relocationPoint;
  bool _isRelocating = false;

  double get _geoRadius => (MAX_ZOOM - _centerPosition.zoom + MIN_ZOOM);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMarkerPins();
    _moveToCurrentPosition();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //REQUIRED TO FIX BLANK MAP ISSUE WHEN COMING BACK FROM BACKGROUND
    if (state == AppLifecycleState.resumed) {
      (await _mapController.future).setMapStyle("[]");
    }
  }

  _loadMarkerPins() {
    //LOAD BATTERY PIN
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.BATTERY_PIN,
      mipmaps: false,
    ).then((pin) {
      _batteryContainerPin = pin;
    });
    //LOAD HOUSEHOLD PIN
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppIcons.HOUSEHOLD_PIN,
      mipmaps: false,
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
        AnimatedAlign(
          duration: kThemeAnimationDuration,
          alignment: Alignment(0, widget.isRelocationSuccessful ? 1 : 3),
          child: RelocationSuccessCard(),
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
        _selectedContainer.id,
        _relocationPoint.latitude,
        _relocationPoint.longitude,
      );
      _resetView();
    }
  }

  _showInfoCard(EvContainer selectedContainer) {
    setState(() {
      _selectedContainer = selectedContainer;
      _isRelocating = false;
      _relocationPoint = null;
    });
  }

  _moveToCurrentPosition() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      final Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      (await _mapController.future).animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 13,
          ),
        ),
      );
    });
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
            icon: _getMarkerPin(_selectedContainer.type),
            alpha: 0.5,
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
      onTap: () => _showInfoCard(container),
    );
  }

  BitmapDescriptor _getMarkerPin(EvContainerType containerType) {
    switch (containerType) {
      case EvContainerType.BATTERY:
        return _batteryContainerPin;
      case EvContainerType.HOUSEHOLD:
        return _householdContainerPin;
    }
    return null;
  }
}
