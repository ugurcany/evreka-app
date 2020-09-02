import 'package:domain/domain.dart';

abstract class ContainerRepository {
  Future<List<EvContainer>> createDummyContainers(LatLng latLng);

  Stream<List<EvContainer>> getContainers(LatLng latLng);

  Future<List<EvContainer>> relocateContainer(
      EvContainer container, LatLng newLatLng);

  Future deleteAllContainers();
}
