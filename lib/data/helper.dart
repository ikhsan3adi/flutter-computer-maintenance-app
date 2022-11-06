import 'package:flutter/material.dart';
import 'package:project_maintenance_app/data/data_model.dart';

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

bool strToBool(String s) {
  if (s != '0') {
    return true;
  } else {
    return false;
  }
}

String boolToStr(bool b) {
  if (b) {
    return '1';
  } else {
    return '0';
  }
}

List<Color> profileColor = [
  Colors.redAccent,
  Colors.green,
  Colors.blueAccent,
  Colors.cyan,
  Colors.teal,
  Colors.orangeAccent,
  Colors.purpleAccent,
];

bool connectToDatabase = true;

Teknisi teknisi = Teknisi(id: '0', username: 'ikhsan1234', nama: 'Ikhsan Satriadi'); // default user

// String errorConnection = 'Can\'t connect to the database or\nwrong IP Address';
String errorConnection = 'Tidak bisa konek ke server atau\nUrl Address salah';
String errorDataEmpty = 'Tidak ada data';

String addressPath = 'device_maintenance_dprd';
