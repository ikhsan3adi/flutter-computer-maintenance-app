// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';

class TesQRSaving extends StatefulWidget {
  const TesQRSaving({Key? key, required this.data}) : super(key: key);

  final Uint8List data;

  @override
  State<TesQRSaving> createState() => _TesQRSavingState();
}

class _TesQRSavingState extends State<TesQRSaving> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(title: 'Hanya untuk tes'),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Image.memory(widget.data),
      ),
    );
  }
}
