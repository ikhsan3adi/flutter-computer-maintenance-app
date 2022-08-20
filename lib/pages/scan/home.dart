// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/scan/search_result_page.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class MainHome extends StatelessWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;

            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => const Home();
                break;
              default:
                throw Exception('Invalid route ${settings.name}');
            }

            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: mxAppBar(
          title: 'Pengecekan Perangkat',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/home.png',
              ),
              mxTextButton(
                buttonPadding: 15,
                icon: Icons.add_link,
                label: 'Masukkan kode',
                labelFontSize: 16,
                onPress: () async {
                  final kodeUnit = await openInsertCodeDialog(context: context, controller: controller);

                  if (kodeUnit == null || kodeUnit == '') {
                    // const SnackBar(
                    //   content: Text('Input tidak boleh kosong!'),
                    // );
                  } else {
                    setState(() {
                      var route = MaterialPageRoute(
                        builder: (BuildContext context) => SearchResultPage(
                          kodeUnit: kodeUnit,
                        ),
                      );
                      Navigator.of(_scaffoldKey.currentContext!).push(route);
                    });
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
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) => SearchResultPage(
                        kodeUnit: codeScanner.rawContent,
                      ),
                    );
                    Navigator.of(_scaffoldKey.currentContext!).push(route);
                  } else {
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      );
}

Future<String?> openInsertCodeDialog<String>({required BuildContext context, required controller}) {
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
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Cari data'),
          )
        ],
      );
    },
  );
}
