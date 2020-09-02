import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class RelocateContainerUsecase extends Usecase {
  final _containerRepository = GetIt.I<ContainerRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    EvContainer container = params[0] as EvContainer;
    LatLng latLng = params[1] as LatLng;
    List<EvContainer> containers =
        await _containerRepository.relocateContainer(container, latLng);

    yield RequestResult.success(containers);
  }

  @override
  String get key => "RELOCATE_CONTAINER";
}
