// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget mxTextButton({
  double buttonPadding = 5,
  required String label,
  double? labelFontSize,
  IconData? icon,
  double? iconSize,
  VoidCallback? onPress,
}) {
  return ElevatedButton.icon(
    onPressed: onPress,
    icon: Icon(
      icon,
      size: iconSize,
    ),
    label: Text(
      label,
      style: TextStyle(
        fontSize: labelFontSize,
        fontWeight: FontWeight.w700,
      ),
    ),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.all(buttonPadding),
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   color: colorPrimary,
        //   width: 3,
        // ),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

Widget mxTextButtonNoIcon({
  double buttonPadding = 5,
  required String label,
  double? labelFontSize,
  VoidCallback? onPress,
  // bool hasOutline = true,
}) {
  return ElevatedButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      // foregroundColor: hasOutline ? colorSecondary : Colors.white,
      // backgroundColor: hasOutline ? Colors.white : colorPrimary,
      alignment: Alignment.center,
      padding: EdgeInsets.all(buttonPadding),
      shape: RoundedRectangleBorder(
        // side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: labelFontSize, color: Colors.white),
    ),
  );
}

Widget blueBigText({required String text, double? size = 20, Color? color = Colors.teal, TextAlign? align}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
    textAlign: align,
  );
}
