// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget mxTextFormField(
    {String? textController,
    String? initialValue,
    String? labelText,
    FocusNode? focusNode,
    onChanged,
    IconData? icon,
    validator,
    hintText,
    bool autoFocus = false,
    bool obscure = false,
    int? maxLength,
    suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool readOnly = false}) {
  return TextFormField(
    focusNode: focusNode,
    obscureText: obscure,
    enableSuggestions: false,
    autocorrect: false,
    initialValue: initialValue,
    readOnly: readOnly,
    maxLength: maxLength,
    autofocus: autoFocus,
    controller: TextEditingController(text: textController),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      label: labelText != null ? Text(labelText) : null,
      hintText: hintText,
      suffixIcon: suffixIcon,
    ),
    onChanged: onChanged,
    validator: validator,
    textCapitalization: textCapitalization,
  );
}
