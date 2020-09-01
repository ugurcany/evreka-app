import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/core/navigation.dart';
import 'package:presentation/src/feature/controller.dart';
import 'package:presentation/src/feature/main/main_presenter.dart';

class MainController extends Controller<ViewData, MainPresenter> {
  final _presenter = MainPresenter();
  final _data = MainViewData();

  @override
  MainPresenter get presenter => _presenter;

  @override
  MainViewData get data => _data;

  @override
  init(BuildContext context, Function(VoidCallback) setState) {
    super.init(context, setState);
    observe(
      (_) => presenter.userResult,
      onSuccess: (user) => setState(() {
        data.user = user;
      }),
    );
    observe(
      (_) => presenter.containersResult,
      onSuccess: (containers) => setState(() {
        data.containers = containers;
      }),
    );
  }

  getUser() => presenter.getUser();

  getContainers(double lat, double lng) => presenter.getContainers(lat, lng);

  createContainers(double lat, double lng) =>
      presenter.createContainers(lat, lng);

  onLogoutClicked() {
    presenter.logOut();
    Navigation.navigateToSplash(context);
  }

  onSettingsClicked() {
    Navigation.pop(context);
    Navigation.navigateToSettings(context);
  }
}

class MainViewData extends ViewData {
  User user;
  List<EvContainer> containers;
}
