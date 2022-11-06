// ignore_for_file: avoid_init_to_null, file_names

import 'package:flutter/material.dart';

AppBar mxAppBar({
  required String title,
  TextStyle? style = null,
  bool? centerTitle = true,
  Builder? leading,
  double? elevation = 0,
  Color? backgroundColor,
  Color? foregroundColor = Colors.white,
}) {
  return AppBar(
    leading: leading,
    title: Text(title),
    titleTextStyle: style,
    centerTitle: centerTitle,
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    elevation: elevation,
  );
}
