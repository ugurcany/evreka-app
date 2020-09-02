import 'package:domain/domain.dart';

abstract class ContainerRepository {
  Future<List<EvContainer>> createDummyContainers(LatLng latLng);

  Stream<List<EvContainer>> getContainers(LatLng latLng, double radius);

  Future relocateContainer(String containerId, LatLng newLatLng);

  Future deleteAllContainers();
}
