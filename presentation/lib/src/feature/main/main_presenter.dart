import 'package:domain/domain.dart';
import 'package:mobx/mobx.dart';
import 'package:presentation/src/feature/presenter.dart';

part 'main_presenter.g.dart';

class MainPresenter = MainPresenterBase with _$MainPresenter;

abstract class MainPresenterBase extends Presenter with Store {
  final _getUser = GetUserUsecase();
  final _logout = LogoutUsecase();
  final _createContainers = CreateContainersUsecase();
  final _getContainers = GetContainersUsecase();
  final _relocateContainer = RelocateContainerUsecase();

  @observable
  RequestResult userResult = RequestResult.idle();

  @observable
  RequestResult logoutResult = RequestResult.idle();

  @observable
  RequestResult containersResult = RequestResult.idle();

  @observable
  RequestResult relocationResult = RequestResult.idle();

  @action
  getUser() {
    subscribe(
      _getUser,
      callback: (result) => userResult = result,
    );
  }

  @action
  logOut() {
    subscribe(
      _logout,
      callback: (result) => logoutResult = result,
    );
  }

  @action
  createContainers(double lat, double lng) {
    subscribe(
      _createContainers,
      params: LatLng(lat, lng),
      callback: (result) => containersResult = result,
    );
  }

  @action
  getContainers(double lat, double lng, double radius) {
    subscribe(
      _getContainers,
      params: [
        LatLng(lat, lng),
        radius,
      ],
      callback: (result) => containersResult = result,
    );
  }

  @action
  relocateContainer(String containerId, double lat, double lng) {
    subscribe(
      _relocateContainer,
      params: [
        containerId,
        LatLng(lat, lng),
      ],
      callback: (result) => relocationResult = result,
    );
  }
}
