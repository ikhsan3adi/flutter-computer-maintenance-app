import 'package:flutter/material.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/show_data/ruangan.dart';

class ShowDataPage extends StatelessWidget {
  const ShowDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Lihat Data',
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
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => const DataRuangan(),
            settings: settings,
          );
        },
      ),
    );
  }
}
