import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/search_data/search_result.dart';

final Image lightHero = Image.asset('assets/images/home.png');
final Image darkHero = Image.asset('assets/images/home-dark.png');

ValueNotifier<Image> heroImageNotifier = ValueNotifier(lightHero);

class ScanSearchPage extends StatelessWidget {
  const ScanSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Perawatan Komputer & Printer',
        leading: Builder(
          builder: ((context) {
            return IconButton(
              onPressed: () {
                openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<Image>(
                valueListenable: heroImageNotifier,
                builder: (context, value, child) => value,
              ),
              mxTextButton(
                buttonPadding: 15,
                icon: Icons.add_link,
                label: 'Masukkan kode',
                labelFontSize: 16,
                onPress: () async {
                  final String? kodeUnit = await openInsertCodeDialog(context: context);

                  if (kodeUnit != '' && kodeUnit != null) {
                    _goToSearchPage(kodeUnit);
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              mxTextButton(
                buttonPadding: 15,
                icon: Icons.qr_code_2_outlined,
                label: 'Scan QR/Barcode',
                labelFontSize: 16,
                onPress: () async {
                  ScanResult codeScanner = await BarcodeScanner.scan(); //barcode scanner
                  if (codeScanner.rawContent != '') {
                    _goToSearchPage(codeScanner.rawContent);
                  } else {
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToSearchPage(String kodeUnit) {
    var route = MaterialPageRoute(builder: (BuildContext context) => SearchResultPage(kodeUnit: kodeUnit));
    Navigator.of(coreScaffoldKey.currentContext!).push(route);
  }
}

Future<String?> openInsertCodeDialog<String>({required BuildContext context}) {
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Masukkan Kode'),
        content: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Kode Unit'),
            hintText: 'contoh : FS-23',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text == '') {
                Fluttertoast.showToast(msg: 'Field tidak boleh kosong');
              } else if (controller.text.length < 5) {
                Fluttertoast.showToast(msg: 'Kode perangkat berisi minimal 5 karakter');
              } else {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('Cari data'),
          )
        ],
      );
    },
  );
}
