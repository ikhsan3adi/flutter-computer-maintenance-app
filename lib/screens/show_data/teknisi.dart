import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myFloatingActionButton.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/add_data/add_teknisi.dart';

class DataTeknisi extends StatefulWidget {
  const DataTeknisi({Key? key}) : super(key: key);

  @override
  State<DataTeknisi> createState() => _DataTeknisiState();
}

class _DataTeknisiState extends State<DataTeknisi> {
  List<Teknisi> listTeknisi = [];

  // fetch data from API
  Future<List<Teknisi>> fetchDataTeknisi() async {
    http.Response? response = await queryData(httpVerbs: httpGET, context: ctxTeknisi, action: actSelect);

    try {
      final List teknisi = json.decode(response.body);
      listTeknisi = teknisi.map((t) => Teknisi.fromJson(t)).toList();
      return listTeknisi;
    } catch (e) {
      throw Exception(errorDataEmpty);
    }
  }

  late Future<List<Teknisi>> myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = fetchDataTeknisi();
  }

  GlobalKey<ScaffoldState> teknisiState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: teknisiState,
      appBar: mxAppBar(
        title: 'Data Teknisi',
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {
              myFuture = fetchDataTeknisi();
            });
          });
        },
        child: FutureBuilder<List<Teknisi>>(
          future: myFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return mxDataLoading();
              case ConnectionState.done:
              default:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= snapshot.data!.length) {
                        return const SizedBox(height: 75);
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: currentTheme,
                          builder: (context, value, _) {
                            return mxCardListTile(
                              childLeading: const Icon(
                                Icons.person_search_outlined,
                                color: Colors.white,
                              ),
                              index: index,
                              titleText: Text(snapshot.data![index].nama),
                              subtitleText: 'username : ${snapshot.data![index].username}',
                              onTap: () => Fluttertoast.showToast(msg: 'Say hello to mr. ${snapshot.data![index].nama}'),
                            );
                          },
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  String errMsg = snapshot.error.toString();
                  if (errMsg == 'Exception: $errorConnection') {
                    return mxErrorFuture(
                      snapshotErr: errMsg,
                      onPress: () {
                        setState(() {
                          myFuture = fetchDataTeknisi();
                        });
                      },
                    );
                  } else if (errMsg == 'Exception: $errorDataEmpty') {
                    return mxErrorFuture(
                      snapshotErr: errMsg,
                      icon: Icons.search_off_outlined,
                      textColor: Colors.grey,
                      onPress: () {
                        setState(() {
                          myFuture = fetchDataTeknisi();
                        });
                      },
                    );
                  }
                }
            }

            return mxDataLoading();
          },
        ),
      ),
      floatingActionButton: mxFloatingActionButton(
        label: 'Tambah teknisi',
        tooltip: 'Tambah teknisi',
        onPressed: () {
          var route = MaterialPageRoute(builder: ((context) => const AddTeknisi()));
          Navigator.of(coreScaffoldKey.currentContext!).push(route);
        },
      ),
    );
  }
}
