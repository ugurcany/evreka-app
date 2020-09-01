import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ContainerRepositoryImpl implements ContainerRepository {
  final _geo = Geoflutterfire();
  final _firestore = Firestore.instance;

  @override
  Future<List<EvContainer>> createDummyContainers(LatLng latLng) async {
    final futures = List<Future>();
    final containers = List<EvContainer>();

    await _deleteAllContainers();
    for (var i = 1; i <= 10; i++) {
      GeoFirePoint location = _geo.point(
        latitude: latLng.lat + _generateRandomLocationOffset(),
        longitude: latLng.lng + _generateRandomLocationOffset(),
      );

      final container = EvContainer(
        id: "#$i",
        fullness: 0.50,
        nextCollection: DateTime.now(),
        latLng: LatLng(location.latitude, location.longitude),
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

  double _generateRandomLocationOffset() {
    return (Random().nextDouble() * 0.01) * (Random().nextBool() ? 1 : -1);
  }

  Future _deleteAllContainers() async {
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
    double radius = 10;
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
}
