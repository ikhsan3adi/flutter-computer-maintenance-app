// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget mxTextFormField(
    {String? textController,
    String? initialValue,
    String? labelText,
    onChanged,
    IconData? icon,
    validator,
    hintText,
    bool autoFocus = false,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool readOnly = false}) {
  return TextFormField(
    initialValue: initialValue,
    readOnly: readOnly,
    maxLength: maxLength,
    autofocus: autoFocus,
    controller: TextEditingController(text: textController),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      label: Text(labelText!),
      hintText: hintText,
    ),
    onChanged: onChanged,
    validator: validator,
    textCapitalization: textCapitalization,
  );
}
