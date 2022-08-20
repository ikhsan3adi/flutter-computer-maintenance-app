class Ruangan {
  String id;
  String namaRuangan;
  String kode;

  Ruangan({required this.id, required this.namaRuangan, required this.kode});

  factory Ruangan.fromJson(Map<String, dynamic> jsonData) {
    return Ruangan(
      id: jsonData['id'],
      namaRuangan: jsonData['nama_ruangan'],
      kode: jsonData['kode'],
    );
  }
}

class Perangkat {
  String kodeUnit;
  String namaUser;
  String namaUnit;
  String type;
  String ruangan;
  String keterangan;

  Perangkat({
    required this.kodeUnit,
    required this.namaUser,
    required this.namaUnit,
    required this.type,
    required this.ruangan,
    required this.keterangan,
  });

  factory Perangkat.fromJson(Map<String, dynamic> jsonData) {
    return Perangkat(
      kodeUnit: jsonData['kode_unit'],
      namaUser: jsonData['nama_user'],
      namaUnit: jsonData['nama_unit'],
      type: jsonData['type'],
      ruangan: jsonData['ruangan'],
      keterangan: jsonData['keterangan'],
    );
  }
}

class Perawatan {
  int id;
  String kodeUnit;
  String tanggal;
  bool pembersihan;
  bool pengecekanChipset;
  bool scanVirus;
  bool pembersihanTemporary;
  bool pengecekanSoftware;
  bool installUpdateDriver;
  String keterangan;
  String teknisi;

  Perawatan({
    required this.id,
    required this.kodeUnit,
    required this.tanggal,
    required this.pembersihan,
    required this.pengecekanChipset,
    required this.scanVirus,
    required this.pembersihanTemporary,
    required this.pengecekanSoftware,
    required this.installUpdateDriver,
    required this.keterangan,
    required this.teknisi,
  });

  factory Perawatan.fromJson(Map<String, dynamic> jsonData) {
    return Perawatan(
      id: int.parse(jsonData['id']),
      kodeUnit: jsonData['kode_unit'],
      tanggal: jsonData['tanggal_pengecekan'],
      pembersihan: strToBool(jsonData['pembersihan']),
      pengecekanChipset: strToBool(jsonData['pengecekan_chipset']),
      scanVirus: strToBool(jsonData['scan_virus']),
      pembersihanTemporary: strToBool(jsonData['pembersihan_temporary']),
      pengecekanSoftware: strToBool(jsonData['pengecekan_software']),
      installUpdateDriver: strToBool(jsonData['install_update_driver']),
      keterangan: jsonData['keterangan'],
      teknisi: jsonData['nama_teknisi'],
    );
  }
}

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

bool connectToDatabase = true;

// String errorConnection = 'Can\'t connect to the database or\nwrong IP Address';
String errorConnection = 'Tidak bisa konek ke server atau\nIP Address salah';
String errorDataEmpty = 'Tidak ada data';

String apiPath = 'perawatan_device_dprd';
