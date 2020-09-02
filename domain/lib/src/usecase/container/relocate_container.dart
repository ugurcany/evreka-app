import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class RelocateContainerUsecase extends Usecase {
  final _containerRepository = GetIt.I<ContainerRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    String containerId = params[0] as String;
    LatLng latLng = params[1] as LatLng;
    await _containerRepository.relocateContainer(containerId, latLng);

    yield RequestResult.success(true);
  }

  @override
  String get key => "RELOCATE_CONTAINER";
}
