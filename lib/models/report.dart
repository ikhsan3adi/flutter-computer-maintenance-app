// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/pdf.util.dart';

class PdfPerawatanReport {
  final String waktu;
  final List<Perawatan?> perawatan;
  final String perangkat;

  final Widget header;
  final Table reportDataTable;
  final Widget footer;

  final Widget report;

  const PdfPerawatanReport({
    required this.waktu,
    required this.perawatan,
    required this.perangkat,
    required this.header,
    required this.reportDataTable,
    required this.footer,
    required this.report,
  });

  static Future<Uint8List> generate(PdfPerawatanReport report) async {
    final pdf = Document();

    final ByteData base = await rootBundle.load('assets/fonts/calibri.ttf');
    final ByteData bold = await rootBundle.load('assets/fonts/calibrib.ttf');
    final ByteData icon = await rootBundle.load('assets/fonts/Check.ttf');

    pdf.addPage(
      MultiPage(
        theme: ThemeData.withFont(
          base: Font.ttf(base),
          bold: Font.ttf(bold),
          icons: Font.ttf(icon),
        ),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) => [
          Center(child: report.report),
        ],
      ),
    );

    return await PdfApi.printDocument(name: report.waktu, pdf: pdf);
  }

  factory PdfPerawatanReport.buildReport({required List<Perawatan?> perawatan, required Perangkat perangkat, required String waktu}) {
    // build report
    final Widget header = buildHeader(perangkat: perangkat, waktu: waktu);
    final Table reportDataTable = buildTable(perawatan: perawatan, perangkat: perangkat.perangkat);
    final Widget footer = buildFooter();

    final Column report = Column(
      children: [
        header,
        SizedBox(height: 30),
        reportDataTable,
        SizedBox(height: 30),
        footer,
      ],
    );

    return PdfPerawatanReport(
      perawatan: perawatan,
      perangkat: perangkat.perangkat,
      header: header,
      reportDataTable: reportDataTable,
      footer: footer,
      report: report,
      waktu: waktu,
    );
  }

  static Widget buildHeader({required Perangkat perangkat, required String waktu}) {
    final boldStyle = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('SEKRETARIAT DPRD PROVINSI JAWA BARAT', style: boldStyle),
        Text('LAPORAN PERAWATAN PERANGKAT', style: boldStyle),
        Text(waktu, style: boldStyle),
        SizedBox(height: 25),
        Row(
          children: [
            Table(children: [
              TableRow(children: [
                Text('User '),
                Text(' : '),
                Text(perangkat.namaUser),
              ]),
              TableRow(children: [
                Text('Ruangan '),
                Text(' : '),
                Text(perangkat.ruangan),
              ]),
              TableRow(children: [
                Text('Kode unit '),
                Text(' : '),
                Text(perangkat.kodeUnit),
              ]),
              TableRow(children: [
                Text('Jenis perangkat '),
                Text(' : '),
                Text(perangkat.perangkat),
              ]),
            ]),
            Spacer(flex: 6),
          ],
        ),
      ],
    );
  }

  static Widget buildFooter() {
    final now = DateTime.now();

    final year = now.year.toString();
    final month = now.month.toString();
    final date = now.day.toString();

    final String waktu = "$date ${bulan[int.parse(month)]} $year";

    final boldUnderlineStyle = TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline);

    return Row(
      children: [
        Spacer(flex: 6),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bandung, $waktu'),
            Text('Pembuat Laporan'),
            SizedBox(height: 80),
            Text(
              teknisi.nama,
              style: boldUnderlineStyle,
            ),
          ],
        )
      ],
    );
  }

  static Table buildTable({required List<Perawatan?> perawatan, required String perangkat}) {
    final List<List<Widget>> rows;

    switch (perangkat) {
      case 'printer':
        rows = getPrinterRows(perawatan as List<PerawatanPrinter>);
        break;
      case 'komputer':
      default:
        rows = getKomputerRows(perawatan as List<PerawatanKomputer>);
    }

    final tableChild = rows.map((e) {
      return TableRow(
          children: e.map((e) {
        return Padding(
          child: e,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        );
      }).toList());
    }).toList();

    tableChild.insert(
      0,
      TableRow(
          children: getHeaders(perawatan).map((e) {
        return Padding(
          child: e,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        );
      }).toList()),
    );

    return Table(
      border: TableBorder.all(),
      children: tableChild,
    );
  }

  static List<Widget> getHeaders(List<Perawatan?> perawatan) {
    final List<Widget> headers = filterData(perawatan).map((e) {
      return Text(
        e!.tanggal,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }).toList();

    headers.insert(0, Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)));

    return headers;
  }

  static Widget boolToIcon(bool b) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(b ? const IconData(0xe800) : const IconData(0xe801), size: 12)],
    );
  }

  static List filterData(List data) {
    Map<int, dynamic> newData = Map.from(data.asMap());
    newData.removeWhere((key, value) => key > 3);
    return newData.values.toList();
  }

  static List<List<Widget>> getKomputerRows(List<PerawatanKomputer?> perawatans) {
    final List<List<Widget>> row = [
      filterData(perawatans).map((e) => boolToIcon(e!.pembersihan)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.pengecekanChipset)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.scanVirus)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.pembersihanTemporary)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.pengecekanSoftware)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.installUpdateDriver)).toList(),
      filterData(perawatans).map((e) => SizedBox(width: 50, child: Text(e!.teknisi))).toList(),
      filterData(perawatans).map((e) => SizedBox(width: 50, child: Text(e!.keterangan, textAlign: TextAlign.justify))).toList(),
    ];

    final List<dynamic> leadings = [
      'Pembersihan',
      'Pengecekan chipset',
      'Scan virus',
      'Pembersihan temporary files',
      'Pengecekan software',
      'Install update software',
      'Teknisi',
      'Keterangan'
    ];

    for (int i = 0; i < row.length; i++) {
      row[i].insert(0, SizedBox(child: Text(leadings[i])));
    }

    return row;
  }

  static List<List<Widget>> getPrinterRows(List<PerawatanPrinter?> perawatans) {
    final List<List<Widget>> row = [
      filterData(perawatans).map((e) => boolToIcon(e!.pembersihan)).toList(),
      filterData(perawatans).map((e) => boolToIcon(e!.installUpdateDriver)).toList(),
      filterData(perawatans).map((e) => SizedBox(width: 50, child: Text(e!.teknisi))).toList(),
      filterData(perawatans).map((e) => SizedBox(width: 50, child: Text(e!.keterangan, textAlign: TextAlign.justify))).toList(),
    ];

    final List<dynamic> leadings = ['Pembersihan', 'Install update software', 'Teknisi', 'Keterangan'];

    for (int i = 0; i < row.length; i++) {
      row[i].insert(0, SizedBox(child: Text(leadings[i])));
    }

    return row;
  }
}
