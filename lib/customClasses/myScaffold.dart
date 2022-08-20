// ignore_for_file: avoid_init_to_null, file_names

import 'package:flutter/material.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';

AppBar mxAppBar({
  required String title,
  TextStyle? style = null,
  bool? centerTitle = true,
  Builder? leading,
  double? elevation = 0,
  Color? backgroundColor = Colors.transparent,
}) {
  return AppBar(
    leading: leading,
    title: Text(title),
    titleTextStyle: style,
    centerTitle: centerTitle,
    foregroundColor: Colors.blueAccent,
    backgroundColor: backgroundColor,
    elevation: elevation,
  );
}

class MxDrawer extends StatefulWidget {
  const MxDrawer({Key? key}) : super(key: key);

  @override
  State<MxDrawer> createState() => _MxDrawerState();
}

class _MxDrawerState extends State<MxDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Material(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              mxBuildMenuItem(
                icon: Icons.signal_wifi_4_bar_lock,
                titleText: 'Server IP Address',
                subtitle: iPAddress,
                onClicked: () {
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => const IPAddressPage()),
                      ),
                    );
                  });
                },
              ),
              // mxBuildMenuItem(
              //   icon: Icons.cell_wifi_outlined,
              //   titleText: 'Konek',
              //   subtitle: connectToDatabase ? 'On' : 'Off',
              //   onClicked: () {
              //     setState(() {
              //       connectToDatabase = !connectToDatabase;
              //     });
              //   },
              //   trailing: Switch.adaptive(
              //       value: connectToDatabase,
              //       onChanged: (value) {
              //         setState(() {
              //           connectToDatabase = value;
              //         });
              //       }),
              // ),
              // mxBuildMenuItem(
              //   icon: Icons.settings,
              //   titleText: 'Pengaturan',
              //   subtitle: 'Settings',
              //   onClicked: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget mxBuildMenuItem({required IconData icon, required String titleText, String subtitle = '', VoidCallback? onClicked, Widget? trailing}) {
  const iconColor = Colors.blueAccent;
  final textColor = Colors.blue[800];

  return ListTile(
    leading: Icon(icon),
    title: Text(titleText),
    subtitle: Text(
      subtitle,
      style: TextStyle(color: textColor),
    ),
    trailing: trailing,
    iconColor: iconColor,
    onTap: onClicked,
  );
}
