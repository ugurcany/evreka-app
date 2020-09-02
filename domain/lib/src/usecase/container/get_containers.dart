import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class GetContainersUsecase extends Usecase {
  final _containerRepository = GetIt.I<ContainerRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    LatLng latLng = params as LatLng;
    yield* _containerRepository
        .getContainers(latLng)
        .map((containers) => RequestResult.success(containers));
  }

  @override
  String get key => "GET_CONTAINERS";
}
