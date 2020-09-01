import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/core/resources.dart';
import 'package:presentation/src/feature/main/main_controller.dart';
import 'package:presentation/src/feature/main/widget/drawer_item.dart';
import 'package:presentation/src/feature/main/widget/main_drawer.dart';
import 'package:presentation/src/feature/main/widget/map_view.dart';
import 'package:presentation/src/feature/main/widget/user_drawer_header.dart';
import 'package:presentation/src/feature/ui_state.dart';
import 'package:presentation/src/widget/app_scaffold.dart';
import 'package:presentation/src/widget/dialog/yes_no_dialog.dart';
import 'package:presentation/src/widget/toaster.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends UiState<MainPage, MainController> {
  final _controller = MainController();
  BitmapDescriptor _batteryContainerPin;

  @override
  MainController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _loadMarkerPins();
    controller.getUser();
  }

  _loadMarkerPins() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "assets/icons/ic_battery_container.png",
    ).then((pin) {
      _batteryContainerPin = pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: MapView(
        markers: _containersToMarkers(),
        onCameraIdle: (lat, lng) => controller.getContainers(lat, lng),
      ),
      drawer: _drawer(),
    );
  }

  Widget _drawer() {
    return MainDrawer(
      children: [
        UserDrawerHeader(user: controller.data.user),
        Divider(),
        DrawerItem(
          icon: AppIcons.CREATE,
          title: LocaleKeys.main_create_containers.localized(),
          onTap: _createContainers,
        ),
        Expanded(child: const SizedBox()),
        DrawerItem(
          icon: AppIcons.SETTINGS,
          title: LocaleKeys.main_settings.localized(),
          onTap: () => controller.onSettingsClicked(),
        ),
        Divider(),
        DrawerItem(
          icon: AppIcons.LOGOUT,
          title: LocaleKeys.main_logout.localized(),
          onTap: () => showYesNoDialog(
            context,
            title: LocaleKeys.main_logout.localized(),
            message: LocaleKeys.main_logout_message.localized(),
            actionText: LocaleKeys.main_logout.localized(),
            onAction: () => controller.onLogoutClicked(),
          ),
        ),
        const SizedBox(height: Dimens.UNIT_4),
      ],
    );
  }

  _createContainers() async {
    Position position = await getLastKnownPosition();
    if (position != null)
      controller.createContainers(position.latitude, position.longitude);
    else
      Toaster.show(context, LocaleKeys.main_no_last_known_location.localized());
  }

  Set<Marker> _containersToMarkers() {
    return controller.data.containers
            ?.map((container) => Marker(
                  markerId: MarkerId(container.id),
                  position: LatLng(container.latLng.lat, container.latLng.lng),
                  icon: _batteryContainerPin,
                ))
            ?.toSet() ??
        null;
  }
}
