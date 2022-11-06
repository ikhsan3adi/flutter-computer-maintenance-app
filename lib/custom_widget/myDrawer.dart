// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/data/helper.dart';

Widget mxBuildMenuItem({required IconData icon, required String titleText, String? subtitle, VoidCallback? onClicked, Widget? trailing}) {
  var iconColor = colorSecondary;
  final textColor = colorSecondary;

  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
    leading: Icon(icon),
    title: Text(titleText),
    subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: textColor)) : null,
    trailing: trailing,
    iconColor: iconColor,
    onTap: onClicked,
  );
}

class DrawerHead extends StatelessWidget {
  const DrawerHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 23),
      leading: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: CircleAvatar(
          backgroundColor: profileColor[Random().nextInt(profileColor.length)],
          foregroundColor: Colors.white,
          child: Text(teknisi.nama.substring(0, 1).toUpperCase()),
        ),
      ),
      title: Text(teknisi.nama),
      subtitle: Text(teknisi.username, style: TextStyle(color: colorSecondary)),
    );
  }
}
