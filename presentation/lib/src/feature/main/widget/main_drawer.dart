import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final List<Widget> children;

  MainDrawer({
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
