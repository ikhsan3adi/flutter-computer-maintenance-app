import 'package:flutter/material.dart' as mt;
import 'package:project_maintenance_app/models/data_model.dart';

List<String> bulan = [
  '',
  'Januari',
  'Febuari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

bool strToBool(String s) => s != '0' ? true : false;

String boolToStr(bool b) => b ? '1' : '0';

List<mt.Color> profileColor = [
  mt.Colors.redAccent,
  mt.Colors.green,
  mt.Colors.blueAccent,
  mt.Colors.cyan,
  mt.Colors.teal,
  mt.Colors.orangeAccent,
  mt.Colors.purpleAccent,
  mt.Colors.indigo,
];

// default user
Teknisi teknisi = Teknisi(id: '35', username: 'ikhsan1234', nama: 'Ikhsan Satriadi');

// String errorConnection = 'Can\'t connect to the database or\nwrong IP Address';
String errorConnection = 'Tidak bisa konek ke server atau\nUrl Address salah';
String errorDataEmpty = 'Tidak ada data';
