import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/navigation.dart';
import 'package:presentation/src/feature/controller.dart';
import 'package:presentation/src/feature/main/main_presenter.dart';
import 'package:presentation/src/widget/toaster.dart';

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
      onLoading: () => setState(() {
        data.isLoading = true;
      }),
      onError: (error) {
        setState(() {
          data.isLoading = false;
        });
        Toaster.show(context, LocaleKeys.common_error.localized());
      },
      onSuccess: (containers) => setState(() {
        data.isLoading = false;
        data.containers = containers;
      }),
    );
    observe(
      (_) => presenter.relocationResult,
      onLoading: () => setState(() {
        data.isLoading = true;
      }),
      onError: (error) {
        setState(() {
          data.isLoading = false;
        });
        Toaster.show(context, LocaleKeys.common_error.localized());
      },
      onSuccess: (_) => setState(() {
        data.isLoading = false;
      }),
    );
  }

  getUser() => presenter.getUser();

  getContainers(double lat, double lng, double radius) =>
      presenter.getContainers(lat, lng, radius);

  createContainers(double lat, double lng) {
    Navigation.pop(context);
    presenter.createContainers(lat, lng);
  }

  relocateContainer(String containerId, double lat, double lng) =>
      presenter.relocateContainer(containerId, lat, lng);

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
  bool isLoading = false;
}
