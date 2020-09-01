import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class CreateContainersUsecase extends Usecase {
  final _containerRepository = GetIt.I<ContainerRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    LatLng latLng = params as LatLng;
    List<EvContainer> containers =
        await _containerRepository.createDummyContainers(latLng);

    yield RequestResult.success(containers);
  }

  @override
  String get key => "CREATE_CONTAINERS";
}
