import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan.dart';

class AddPerawatanKomputer extends StatefulWidget {
  const AddPerawatanKomputer({Key? key, required this.perangkat}) : super(key: key);

  final Perangkat perangkat;

  @override
  State<AddPerawatanKomputer> createState() => _AddPerawatanKomputerState();
}

class _AddPerawatanKomputerState extends State<AddPerawatanKomputer> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  late PerawatanKomputer newPerawatan = PerawatanKomputer(
    id: 0,
    kodeUnit: '',
    tanggal: '',
    pembersihan: false,
    pengecekanChipset: false,
    scanVirus: false,
    pembersihanTemporary: false,
    pengecekanSoftware: false,
    installUpdateDriver: false,
    keterangan: '',
    teknisi: '',
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
                  mxTextFormField(
                    textController: newPerawatan.teknisi,
                    labelText: 'Nama teknisi',
                    icon: Icons.person_search,
                    onChanged: (v) {
                      newPerawatan.teknisi = v!;
                    },
                    validator: (value) {
                      if (value!.length > 32) {
                        return 'Maks. 32 karakter';
                      } else if (value.isEmpty) {
                        return 'Nama teknisi tidak boleh kosong!';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
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
                              title: 'Pembersihan komponen komputer',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pembersihan = v!;
                                });
                              },
                              value: newPerawatan.pembersihan),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Pengecekan dan pemberian pasta pada chipset',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pengecekanChipset = v!;
                                });
                              },
                              value: newPerawatan.pengecekanChipset),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Scan virus + update',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.scanVirus = v!;
                                });
                              },
                              value: newPerawatan.scanVirus),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Pembersihan sampah binary dan temporary files',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pembersihanTemporary = v!;
                                });
                              },
                              value: newPerawatan.pembersihanTemporary),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Perawatan dan pengecekan software yang terinstall',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pengecekanSoftware = v!;
                                });
                              },
                              value: newPerawatan.pengecekanSoftware),
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
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextButtonNoIcon(
                      buttonPadding: 20,
                      hasOutline: false,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
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
                              perangkat: 'komputer',
                            ),
                          );
                          Navigator.of(context).push(route);
                        }
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
