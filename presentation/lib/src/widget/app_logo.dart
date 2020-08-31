import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  AppLogo({
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/app_logo.svg",
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
