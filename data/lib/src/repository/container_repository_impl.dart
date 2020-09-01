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
    for (var i = 1; i <= 20; i++) {
      GeoFirePoint location = _geo.point(
        latitude: _generateDouble(latLng.lat - 0.1, latLng.lat + 0.1),
        longitude: _generateDouble(latLng.lng - 0.1, latLng.lng + 0.1),
      );

      final container = EvContainer(
        id: "#$i",
        fullness: _generateDouble(0, 0.99),
        nextCollection: DateTime.now(),
        latLng: LatLng(location.latitude, location.longitude),
        type: i % 2 == 0 ? EvContainerType.HOUSEHOLD : EvContainerType.BATTERY,
      );
      containers.add(container);

      futures.add(
        _firestore.collection("containers").add(
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
  Stream<List<EvContainer>> getContainers(LatLng latLng) async* {
    GeoFirePoint center = _geo.point(
      latitude: latLng.lat,
      longitude: latLng.lng,
    );
    double radius = 50;
    String field = "location";

    Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: _firestore.collection("containers"))
        .within(
          center: center,
          radius: radius,
          field: field,
        );

    yield* stream.map<List<EvContainer>>((snapshots) =>
        snapshots.map((ds) => EvContainer.fromJson(ds.data)).toList());
  }

  double _generateDouble(double min, double max) =>
      min + _random.nextDouble() * (max - min);
}
