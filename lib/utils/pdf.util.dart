// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future<File> saveDocument({required String name, required pw.Document pdf}) async {
    final List<int> bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();

    final file = File('${dir!.path}/$name');

    file.writeAsBytesSync(bytes);

    return file;
  }

  static Future<Uint8List> printDocument({required String name, required pw.Document pdf}) async {
    final Uint8List bytes = await pdf.save();

    return bytes;
  }
}
