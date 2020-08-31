import 'package:flutter/material.dart';
import 'package:presentation/src/feature/controller.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/navigation.dart';
import 'package:presentation/src/widget/toaster.dart';
import 'package:presentation/src/feature/splash/splash_presenter.dart';

class SplashController extends Controller<SplashViewData, SplashPresenter> {
  final _presenter = SplashPresenter();
  final _data = SplashViewData();

  @override
  SplashPresenter get presenter => _presenter;

  @override
  SplashViewData get data => _data;

  @override
  init(BuildContext context, Function(VoidCallback) setState) {
    super.init(context, setState);
    observe(
      (_) => presenter.loginResult,
      onLoading: () => setState(() => data.showAuth = false),
      onSuccess: (isLoggedIn) {
        if (isLoggedIn == true)
          Navigation.navigateToMain(context);
        else
          setState(() => data.showAuth = true);
      },
      onError: (error) {
        setState(() => data.showAuth = true);
        Toaster.show(context, LocaleKeys.splash_login_failed.localized());
      },
    );
  }

  checkIsLoggedInAfterDelay() {
    runDelayed(
      const Duration(seconds: 2),
      () => presenter.isLoggedIn(),
    );
  }

  get onGoogleLoginClicked =>
      data.showAuth ? () => presenter.logInWithGoogle() : null;
}

class SplashViewData extends ViewData {
  bool showAuth = false;
}
