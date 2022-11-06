import 'package:flutter/material.dart';
import 'package:project_maintenance_app/custom_widget/myDrawer.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/home_page.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';
import 'package:project_maintenance_app/pages/show_data_page.dart';

int currentPageIndex = 0;
ValueNotifier<int> pageIndex = ValueNotifier(currentPageIndex);
ValueNotifier<String> drawerUrlText = ValueNotifier(url);

GlobalKey<ScaffoldState> coreScaffoldKey = GlobalKey();

final screen = [
  const Home(),
  const ShowDataPage(),
];

class Core extends StatelessWidget {
  const Core({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: coreScaffoldKey,
      body: ValueListenableBuilder<int>(
        valueListenable: pageIndex,
        builder: (context, value, _) => screen[value],
      ),
      drawer: mxDrawer(context),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: pageIndex,
        builder: (context, value, _) {
          return BottomNavigationBar(
            onTap: (value) {
              pageIndex.value = value;
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: pageIndex.value,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            enableFeedback: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Lihat Data',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget mxDrawer(BuildContext context) {
    return Drawer(
      // backgroundColor: colorSecondary,
      child: SafeArea(
        child: Material(
          child: ListView(
            children: [
              const DrawerHead(),
              const Divider(thickness: 1),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: currentTheme,
                builder: ((context, value, _) => mxBuildMenuItem(
                      icon: Icons.dark_mode,
                      titleText: 'Mode Gelap',
                      trailing: Switch.adaptive(
                        value: currentTheme.value == ThemeMode.dark,
                        onChanged: (v) {
                          preferences.setBool('useDarkTheme', v);
                          changeToDarkTheme(dark: v);
                        },
                      ),
                    )),
              ),
              const Divider(thickness: 1),
              ValueListenableBuilder<String>(
                valueListenable: drawerUrlText,
                builder: (ctx, value, _) => mxBuildMenuItem(
                  icon: Icons.signal_wifi_4_bar_lock,
                  titleText: 'Ubah URL Server',
                  subtitle: value,
                  onClicked: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const IPAddressPage()))
                        .then((value) => drawerUrlText.value = url);
                  },
                ),
              ),
              mxBuildMenuItem(
                icon: Icons.power_settings_new_outlined,
                titleText: 'Logout',
                onClicked: () {
                  teknisi = Teknisi(id: '', username: '', nama: '');
                  preferences.remove('teknisi');
                  preferences.setBool('loggedIn', false);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void openDrawer() {
  if (coreScaffoldKey.currentState != null) coreScaffoldKey.currentState!.openDrawer();
}

void closeDrawer() {
  if (coreScaffoldKey.currentState != null) coreScaffoldKey.currentState!.closeDrawer();
}
