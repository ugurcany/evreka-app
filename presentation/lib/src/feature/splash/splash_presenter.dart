import 'package:domain/domain.dart';
import 'package:mobx/mobx.dart';
import 'package:presentation/src/feature/presenter.dart';

part 'splash_presenter.g.dart';

class SplashPresenter = SplashPresenterBase with _$SplashPresenter;

abstract class SplashPresenterBase extends Presenter with Store {
  final _loginWithGoogle = LoginWithGoogleUsecase();
  final _isLoggedIn = IsLoggedInUsecase();

  @observable
  RequestResult loginResult = RequestResult.idle();

  @action
  isLoggedIn() {
    subscribe(
      _isLoggedIn,
      callback: (result) => loginResult = result,
    );
  }

  @action
  logInWithGoogle() {
    subscribe(
      _loginWithGoogle,
      callback: (result) => loginResult = result,
    );
  }
}
