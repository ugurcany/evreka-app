import 'package:domain/domain.dart';
import 'package:mobx/mobx.dart';
import 'package:presentation/src/feature/presenter.dart';

part 'main_presenter.g.dart';

class MainPresenter = MainPresenterBase with _$MainPresenter;

abstract class MainPresenterBase extends Presenter with Store {
  final _getUser = GetUserUsecase();
  final _logout = LogoutUsecase();

  @observable
  RequestResult userResult = RequestResult.idle();

  @observable
  RequestResult logoutResult = RequestResult.idle();

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
}
