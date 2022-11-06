// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project_maintenance_app/main.dart';

Widget mxFloatingActionButton({required String label, String? tooltip, VoidCallback? onPressed}) {
  return ValueListenableBuilder<ThemeMode>(
    valueListenable: currentTheme,
    builder: (context, value, _) {
      return FloatingActionButton.extended(
        foregroundColor: value == ThemeMode.light ? Colors.white : null,
        onPressed: onPressed,
        tooltip: tooltip,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        label: Text(label),
        icon: const Icon(
          Icons.add,
          size: 30,
        ),
      );
    },
  );
}
