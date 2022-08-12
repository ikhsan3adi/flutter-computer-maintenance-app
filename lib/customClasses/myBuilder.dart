// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';

Widget mxListViewBuilder({required snapshot, required itemBuilder, VoidCallback? onTap}) {
  return ListView.builder(
    itemCount: snapshot.data!.length,
    itemBuilder: itemBuilder,
  );
}

Widget mxCardListTile(
    {required snapshot,
    index,
    required titleText,
    String? subtitleText,
    VoidCallback? onTap,
    Widget? childLeading,
    foregroundImage,
    Color? leadingBackgroundColor = Colors.blue,
    Color? leadingForegroundColor = Colors.blue,
    Color? cardColor}) {
  cardColor ??= index % 2 == 0 ? Colors.white : Colors.lightBlue[50];

  return Card(
    color: cardColor,
    child: ListTile(
      leading: CircleAvatar(
        foregroundColor: leadingForegroundColor,
        backgroundColor: leadingBackgroundColor,
        foregroundImage: foregroundImage,
        child: childLeading,
      ),
      title: Text(titleText),
      subtitle: Text(subtitleText!),
      onTap: onTap,
    ),
  );
}

Widget mxErrorFuture({
  required String snapshotErr,
  IconData? icon = Icons.signal_wifi_bad,
  String labelBtn = 'Refresh',
  IconData? iconRefresh = Icons.refresh_outlined,
  VoidCallback? onPress,
  Color? textColor = Colors.redAccent,
  Color? iconColor = Colors.grey,
  double? fontSize = 16,
  bool secondButton = false,
  String labelBtn2 = '',
  IconData? iconBtn2,
  VoidCallback? onPress2,
}) {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 80,
            ),
            const SizedBox(height: 15),
            Text(
              snapshotErr,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: fontSize),
            ),
            const SizedBox(height: 15),
            mxTextButton(
              buttonPadding: 10,
              label: labelBtn,
              icon: iconRefresh,
              onPress: onPress,
            ),
            secondButton ? const SizedBox(height: 15) : const SizedBox(),
            secondButton ? mxTextButton(buttonPadding: 10, label: labelBtn2, icon: iconBtn2, onPress: onPress2) : const SizedBox(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    ),
  );
}

Widget mxDataLoading({String? text = 'Loading data'}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpinKitFadingCube(
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 30),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.blueAccent, fontSize: 18),
        ),
      ],
    ),
  );
}
