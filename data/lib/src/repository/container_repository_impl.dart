import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ContainerRepositoryImpl implements ContainerRepository {
  final _geo = Geoflutterfire();
  final _firestore = Firestore.instance;
  final _random = Random();

  @override
  Future<List<EvContainer>> createDummyContainers(LatLng latLng) async {
    final futures = List<Future>();
    final containers = List<EvContainer>();

    //DELETE ALL CONTAINERS FIRST
    await deleteAllContainers();

    //CREATE AND ADD DUMMY CONTAINERS TO FIRESTOREE
    for (var i = 1; i <= 1000; i++) {
      GeoFirePoint location = _geo.point(
        latitude: _generateDouble(latLng.lat - 0.4, latLng.lat + 0.4),
        longitude: _generateDouble(latLng.lng - 0.4, latLng.lng + 0.4),
      );

      final container = EvContainer(
        id: "#$i",
        fullness: _generateDouble(0, 0.99),
        temperature: _generateDouble(20, 60),
        nextCollection: DateTime.fromMillisecondsSinceEpoch(1601307062000),
        latLng: LatLng(location.latitude, location.longitude),
        type: i % 2 == 0 ? EvContainerType.HOUSEHOLD : EvContainerType.BATTERY,
      );
      containers.add(container);

      futures.add(
        _firestore.collection("containers").document(container.id).setData(
            container.toJson()..putIfAbsent("location", () => location.data)),
      );
    }

    //Wait for all futures to complete
    await Future.wait(futures);

    return containers;
  }

  @override
  Future deleteAllContainers() async {
    final futures = List<Future>();

    await _firestore.collection("containers").getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        futures.add(ds.reference.delete());
      }
    });

    //Wait for all futures to complete
    await Future.wait(futures);
  }

  @override
  Stream<List<EvContainer>> getContainers(LatLng latLng, double radius) async* {
    GeoFirePoint center = _geo.point(
      latitude: latLng.lat,
      longitude: latLng.lng,
    );
    String field = "location";

    Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: _firestore.collection("containers"))
        .within(
          center: center,
          radius: radius,
          field: field,
          strictMode: true,
        );

    yield* stream.map<List<EvContainer>>((snapshots) =>
        snapshots.map((ds) => EvContainer.fromJson(ds.data)).toList());
  }

  @override
  Future relocateContainer(String containerId, LatLng newLatLng) async {
    GeoFirePoint newPoint = _geo.point(
      latitude: newLatLng.lat,
      longitude: newLatLng.lng,
    );

    //UPDATE LOCATION & LATLNG PARAMS
    await _firestore.collection("containers").document(containerId).updateData({
      "location": newPoint.data,
      "latLng": newLatLng.toJson(),
    });
  }

  double _generateDouble(double min, double max) =>
      min + _random.nextDouble() * (max - min);
}
