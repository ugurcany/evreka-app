import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:presentation/src/core/localization.dart';
import 'package:presentation/src/core/localization.g.dart';
import 'package:presentation/src/feature/controller.dart';

abstract class UiState<W extends StatefulWidget, C extends Controller>
    extends State<W> {
  C get controller;

  @override
  void initState() {
    controller.init(context, setState);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget content(BuildContext context) {
    //OVERRIDE THIS TO SET YOUR CONTENT
    return Container();
  }

  Widget loading(BuildContext context) {
    return AbsorbPointer(
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.4),
          ),
          child: SpinKitFadingCircle(
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
      ),
    );
  }

  Widget error() {
    return Center(
      child: Text(
        LocaleKeys.common_error.localized(),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
