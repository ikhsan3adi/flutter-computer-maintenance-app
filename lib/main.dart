import 'package:flutter/material.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';
import 'package:project_maintenance_app/pages/scan/home.dart';
import 'package:project_maintenance_app/pages/manageData/ruangan_page.dart';

final screen = [
  const MainHome(),
  const SecondHome(),
];

int currentPageIndex = 0;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

void openDrawer() {
  _scaffoldKey.currentState!.openDrawer();
}

void closeDrawer() {
  _scaffoldKey.currentState!.closeDrawer();
}

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Main(),
      },
    ),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: screen[currentPageIndex],
      drawer: const MxDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        currentIndex: currentPageIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Data Perangkat',
          ),
        ],
      ),
    );
  }
}
