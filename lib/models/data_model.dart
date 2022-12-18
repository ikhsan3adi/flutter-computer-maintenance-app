import 'package:project_maintenance_app/utils/helper.dart';

class Teknisi {
  String id;
  String username;
  String nama;

  Teknisi({
    required this.id,
    required this.username,
    required this.nama,
  });

  factory Teknisi.fromJson(Map<String, dynamic> jsonData) {
    return Teknisi(
      id: jsonData['id'],
      username: jsonData['username'],
      nama: jsonData['nama_teknisi'],
    );
  }
}

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
  String perangkat;
  String namaUser;
  String namaUnit;
  String type;
  String ruangan;
  String keterangan;

  Perangkat({
    required this.kodeUnit,
    required this.perangkat,
    required this.namaUser,
    required this.namaUnit,
    required this.type,
    required this.ruangan,
    required this.keterangan,
  });

  factory Perangkat.fromJson(Map<String, dynamic> jsonData) {
    return Perangkat(
      kodeUnit: jsonData['kode_unit'],
      perangkat: jsonData['perangkat'],
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
  String keterangan;
  String teknisi;

  Perawatan({
    required this.id,
    required this.kodeUnit,
    required this.tanggal,
    required this.keterangan,
    required this.teknisi,
  });
}

class PerawatanKomputer extends Perawatan {
  bool pembersihan;
  bool pengecekanChipset;
  bool scanVirus;
  bool pembersihanTemporary;
  bool pengecekanSoftware;
  bool installUpdateDriver;

  PerawatanKomputer({
    required super.id,
    required super.kodeUnit,
    required super.tanggal,
    required this.pembersihan,
    required this.pengecekanChipset,
    required this.scanVirus,
    required this.pembersihanTemporary,
    required this.pengecekanSoftware,
    required this.installUpdateDriver,
    required super.keterangan,
    required super.teknisi,
  });

  factory PerawatanKomputer.fromJson(Map<String, dynamic> jsonData) {
    return PerawatanKomputer(
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

class PerawatanPrinter extends Perawatan {
  bool pembersihan;
  bool installUpdateDriver;

  PerawatanPrinter({
    required super.id,
    required super.kodeUnit,
    required super.tanggal,
    required this.pembersihan,
    required this.installUpdateDriver,
    required super.keterangan,
    required super.teknisi,
  });

  factory PerawatanPrinter.fromJson(Map<String, dynamic> jsonData) {
    return PerawatanPrinter(
      id: int.parse(jsonData['id']),
      kodeUnit: jsonData['kode_unit'],
      tanggal: jsonData['tanggal_pengecekan'],
      pembersihan: strToBool(jsonData['pembersihan']),
      installUpdateDriver: strToBool(jsonData['install_update_driver']),
      keterangan: jsonData['keterangan'],
      teknisi: jsonData['nama_teknisi'],
    );
  }
}
