import 'package:flutter/material.dart';
import 'package:project_maintenance_app/custom_widget/myDrawer.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/home_page.dart';
import 'package:project_maintenance_app/pages/teknisi_page.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';
import 'package:project_maintenance_app/pages/show_data_page.dart';

int currentPageIndex = 0;
ValueNotifier<int> pageIndex = ValueNotifier(currentPageIndex);
ValueNotifier<String> drawerUrlText = ValueNotifier(url);

GlobalKey<ScaffoldState> coreScaffoldKey = GlobalKey();

bool admin = false;

class Core extends StatelessWidget {
  Core({super.key});

  final screen = [
    const Home(),
    const ShowDataPage(),
  ];

  final navDestination = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Beranda',
    ),
    const NavigationDestination(
      icon: Icon(Icons.list),
      label: 'Lihat Data',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (admin) {
      screen.add(const TeknisiPage());

      navDestination.add(const NavigationDestination(icon: Icon(Icons.person_search_outlined), label: 'Data Teknisi'));
    }

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
          return NavigationBarTheme(
            data: NavigationBarThemeData(
              height: 65,
              backgroundColor: colorSecondary.withOpacity(0.2),
              indicatorColor: colorSecondary.withOpacity(0.3),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            child: NavigationBar(
              onDestinationSelected: (value) {
                pageIndex.value = value;
              },
              selectedIndex: pageIndex.value,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(milliseconds: 500),
              destinations: navDestination,
            ),
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
                onClicked: () async {
                  final bool? logout = await openLogoutDialog(context: context);

                  if (logout != null && logout) {
                    teknisi = Teknisi(id: '', username: '', nama: '');
                    preferences.remove('teknisi');
                    preferences.setBool('loggedIn', false);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> openLogoutDialog<bool>({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah anda ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Ya'),
          )
        ],
      );
    },
  );
}

void pushRootRoute({required MaterialPageRoute route, Function? onFinished}) {
  Navigator.of(coreScaffoldKey.currentContext!).push(route).then((value) => onFinished);
}

void openDrawer() {
  if (coreScaffoldKey.currentState != null) coreScaffoldKey.currentState!.openDrawer();
}

void closeDrawer() {
  if (coreScaffoldKey.currentState != null) coreScaffoldKey.currentState!.closeDrawer();
}
