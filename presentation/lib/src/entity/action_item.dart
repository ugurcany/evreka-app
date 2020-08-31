import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ActionItem extends Equatable {
  final String title;
  final IconData icon;
  final Function onPressed;
  final bool isVisible;

  ActionItem({
    @required this.title,
    @required this.icon,
    this.onPressed,
    this.isVisible = true,
  });

  @override
  List<Object> get props => [title, icon];

  @override
  bool get stringify => true;
}
