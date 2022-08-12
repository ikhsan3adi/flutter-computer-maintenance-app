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
  return TextButton.icon(
    onPressed: onPress,
    icon: Icon(
      icon,
      size: iconSize,
    ),
    label: Text(
      label,
      style: TextStyle(fontSize: labelFontSize),
    ),
    style: ElevatedButton.styleFrom(
      alignment: Alignment.center,
      padding: EdgeInsets.all(buttonPadding),
      primary: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blueAccent, width: 3),
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
  bool hasOutline = true,
}) {
  return TextButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(
      alignment: Alignment.center,
      padding: EdgeInsets.all(buttonPadding),
      primary: hasOutline ? Colors.white : Colors.blueAccent,
      onPrimary: hasOutline ? Colors.blue : Colors.white,
      shape: RoundedRectangleBorder(
        side: hasOutline ? const BorderSide(color: Colors.blueAccent, width: 3) : BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: labelFontSize, color: hasOutline ? Colors.blueAccent : Colors.white),
    ),
  );
}

Widget blueBigText({required String text, double? size = 20, Color? color = Colors.blueAccent, TextAlign? align}) {
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
