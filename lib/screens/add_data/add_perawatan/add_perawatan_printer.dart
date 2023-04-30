import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan.dart';

class AddPerawatanPrinter extends StatefulWidget {
  const AddPerawatanPrinter({Key? key, required this.perangkat}) : super(key: key);

  final Perangkat perangkat;

  @override
  State<AddPerawatanPrinter> createState() => _AddPerawatanPrinterState();
}

class _AddPerawatanPrinterState extends State<AddPerawatanPrinter> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  late PerawatanPrinter newPerawatan = PerawatanPrinter(
    id: 0,
    kodeUnit: '',
    tanggal: '',
    pembersihan: false,
    installUpdateDriver: false,
    keterangan: '',
    teknisi: teknisi.nama,
  );

  @override
  void initState() {
    super.initState();
    newPerawatan.teknisi = teknisi.nama;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Data perawatan baru',
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.maybePop(context);
              },
              tooltip: 'Kembali',
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: ListView(
            children: [
              Card(
                child: Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        title: blueBigText(text: 'Kode : ${widget.perangkat.kodeUnit}', size: 16),
                        subtitle: Text('User :  ${widget.perangkat.namaUser}'),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: blueBigText(text: 'Unit : ${widget.perangkat.namaUnit}', size: 16, align: TextAlign.end),
                        subtitle: Text(
                          'Type :  ${widget.perangkat.type}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan pilih teknisi';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_search),
                      label: Text('Nama teknisi'),
                    ),
                    value: teknisi.id,
                    items: listTeknisi.map((e) => DropdownMenuItem<String>(value: e.id, child: Text(e.nama))).toList(),
                    onChanged: (value) {
                      setState(() {
                        newPerawatan.teknisi = value!;
                      });
                    },
                  ),
                  // mxTextFormField(
                  //   textController: newPerawatan.teknisi,
                  //   labelText: 'Nama teknisi',
                  //   icon: Icons.person_search,
                  //   onChanged: (v) {
                  //     newPerawatan.teknisi = v!;
                  //   },
                  //   validator: (value) {
                  //     if (value!.length > 32) {
                  //       return 'Maks. 32 karakter';
                  //     } else if (value.isEmpty) {
                  //       return 'Nama teknisi tidak boleh kosong!';
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   textCapitalization: TextCapitalization.words,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          mXcheckBoxListTile(
                              title: 'Pembersihan komponen',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pembersihan = v!;
                                });
                              },
                              value: newPerawatan.pembersihan),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Install, update, dan konfigurasi driver',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.installUpdateDriver = v!;
                                });
                              },
                              value: newPerawatan.installUpdateDriver),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      focusNode: focusNode,
                      textController: newPerawatan.keterangan,
                      labelText: 'Keterangan',
                      icon: Icons.more,
                      onChanged: (value) {
                        newPerawatan.keterangan = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                    child: mxTextButtonNoIcon(
                      buttonPadding: 20,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (!isValidForm) return;

                        focusNode.unfocus();

                        var currentTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

                        var y = currentTime.toString().substring(0, 4);
                        var m = currentTime.toString().substring(5, 7);
                        var d = currentTime.toString().substring(8, 10);

                        if (kDebugMode) {
                          print('$y-$m-$d');
                        }

                        newPerawatan.kodeUnit = widget.perangkat.kodeUnit;
                        newPerawatan.tanggal = '$y-$m-$d';

                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => AddPerawatanResult(
                            newPerawatan: newPerawatan,
                            perangkat: 'printer',
                          ),
                        );

                        Navigator.of(context).push(route);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
