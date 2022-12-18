import "package:flutter/material.dart";
import 'package:printing/printing.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myFloatingActionButton.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/models/report.dart';
import 'package:project_maintenance_app/utils/helper.dart';

class PrintPerawatan extends StatefulWidget {
  const PrintPerawatan({super.key, required this.perawatan, required this.perangkat, required this.waktu});

  final List<Perawatan?> perawatan;
  final Perangkat perangkat;
  final String waktu;

  @override
  State<PrintPerawatan> createState() => _PrintPerawatanState();
}

class _PrintPerawatanState extends State<PrintPerawatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(title: 'Print data'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: buildReport(perawatan: widget.perawatan, perangkat: widget.perangkat, waktu: widget.waktu),
        ),
      ),
      floatingActionButton: mxFloatingActionButton(
        label: 'Print',
        icon: Icons.print,
        onPressed: (() async {
          final PdfPerawatanReport pdfPerawatanReport =
              PdfPerawatanReport.buildReport(perawatan: widget.perawatan, waktu: widget.waktu, perangkat: widget.perangkat);

          await Printing.layoutPdf(
            onLayout: (format) {
              return PdfPerawatanReport.generate(pdfPerawatanReport);
            },
          );
        }),
      ),
    );
  }

  static Widget buildReport({required List<Perawatan?> perawatan, required Perangkat perangkat, required String waktu}) {
    // build report
    final Widget header = buildHeader(perangkat: perangkat, waktu: waktu);
    final Table reportDataTable = buildTable(perawatan: perawatan, perangkat: perangkat.perangkat);
    final Widget footer = buildFooter();

    final report = Column(
      children: [
        header,
        // const SizedBox(height: 5),
        Transform.scale(
          scale: 0.85,
          child: reportDataTable,
        ),
        // const SizedBox(height: 5),
        Transform.scale(
          scale: 0.85,
          child: footer,
        ),
      ],
    );

    return report;
  }

  static Widget buildHeader({required Perangkat perangkat, required String waktu}) {
    const boldStyle = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 0.85,
          child: Column(
            children: [
              const Text('SEKRETARIAT DPRD PROVINSI JAWA BARAT', style: boldStyle),
              const Text('LAPORAN PERAWATAN PERANGKAT', style: boldStyle),
              Text(waktu, style: boldStyle),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Transform.scale(
          scale: 0.85,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Table(
                  children: [
                    TableRow(children: [
                      const Text('User '),
                      const Text(' : '),
                      Text(perangkat.namaUser),
                    ]),
                    TableRow(children: [
                      const Text('Ruangan '),
                      const Text(' : '),
                      Text(perangkat.ruangan),
                    ]),
                    TableRow(children: [
                      const Text('Kode unit '),
                      const Text(' : '),
                      Text(perangkat.kodeUnit),
                    ]),
                    TableRow(children: [
                      const Text('Jenis perangkat '),
                      const Text(' : '),
                      Text(perangkat.perangkat),
                    ]),
                  ],
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(6),
                  },
                ),
              ),
              const SizedBox(width: 100)
            ],
          ),
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

    const boldUnderlineStyle = TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline);

    return Row(
      children: [
        const Spacer(flex: 6),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bandung, $waktu'),
            const Text('Pembuat Laporan'),
            const SizedBox(height: 80),
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: e,
        );
      }).toList());
    }).toList();

    tableChild.insert(
      0,
      TableRow(
          children: getHeaders(perawatan).map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: e,
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }).toList();

    headers.insert(0, const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)));

    return headers;
  }

  static Widget boolToIcon(bool b) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(b ? const IconData(0xe800, fontFamily: 'Check') : const IconData(0xe801, fontFamily: 'Check'), size: 12)],
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
