import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presentation/src/core/resources.dart';

class MapContainer extends StatefulWidget {
  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  final _mapController = Completer<GoogleMapController>();

  var _position = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _moveToCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _map(context),
        Align(
          alignment: Alignment.topRight,
          child: _locateMe(context),
        ),
      ],
    );
  }

  Widget _map(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      initialCameraPosition: _position,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      onCameraMove: (CameraPosition position) {
        log("onCameraMove: " +
            position.target.latitude.toString() +
            ", " +
            position.target.longitude.toString());
        setState(() => _position = position);
      },
      onCameraIdle: () async {
        log("onCameraIdle");
      },
    );
  }

  Widget _locateMe(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.UNIT_4),
      child: FloatingActionButton(
        child: Icon(AppIcons.LOCATE_ME),
        onPressed: _moveToCurrentPosition,
      ),
    );
  }

  void _moveToCurrentPosition() async {
    final Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    (await _mapController.future).animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }
}
