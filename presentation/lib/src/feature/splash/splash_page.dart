import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/feature/splash/splash_controller.dart';
import 'package:presentation/src/feature/ui_state.dart';
import 'package:presentation/src/widget/app_logo.dart';
import 'package:presentation/src/widget/primary_button.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends UiState<SplashPage, SplashController> {
  final _controller = SplashController();

  @override
  SplashController get controller => _controller;

  @override
  void initState() {
    super.initState();
    controller.checkIsLoggedInAfterDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Style.LIGHT_GREY_COLOR,
              Style.WHITE_COLOR,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 1, child: const SizedBox()),
            AppLogo(width: MediaQuery.of(context).size.width / 2),
            Expanded(flex: 2, child: _buildAuthButtons(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: controller.data.showAuth ? 1.0 : 0.0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(Dimens.UNIT_8),
        child: PrimaryButton(
          text: LocaleKeys.splash_login_with_google.localized(),
          icon: AppIcons.GOOGLE,
          onPressed: controller.onGoogleLoginClicked,
        ),
      ),
    );
  }
}
