import 'package:flutter/material.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/screens/add_data/add_perangkat/add_device_result.dart';
import 'package:project_maintenance_app/screens/show_data/ruangan.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key, required this.ruangan}) : super(key: key);

  final String ruangan;

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  String placeholderRuangan = 'Pilih ruangan';

  Perangkat newPerangkat = Perangkat(
    kodeUnit: '',
    perangkat: 'komputer',
    namaUser: '',
    namaUnit: '',
    type: '',
    ruangan: '',
    keterangan: '',
  );

  bool dropDownChanged = false;

  @override
  Widget build(BuildContext context) {
    // List<String> ruangan = dummyRuangan.map((e) => e.namaRuangan).toList();
    List<String> ruangan = realRuangan.map((e) => e.namaRuangan).toList();
    ruangan.insert(0, placeholderRuangan);

    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah perangkat baru',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.namaUser,
                      labelText: 'Nama user',
                      onChanged: (value) {
                        newPerangkat.namaUser = value;
                      },
                      icon: Icons.person,
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama user tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Pengguna',
                      autoFocus: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.namaUnit,
                      labelText: 'Nama unit / Merk',
                      onChanged: (value) {
                        newPerangkat.namaUnit = value;
                      },
                      icon: Icons.computer_sharp,
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama unit tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == placeholderRuangan) {
                          return 'Silakan pilih ruangan';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        label: Text('Jenis perangkat'),
                      ),
                      value: newPerangkat.perangkat,
                      items: const [
                        DropdownMenuItem<String>(value: 'komputer', child: Text('Komputer')),
                        DropdownMenuItem<String>(value: 'printer', child: Text('Printer'))
                      ],
                      onChanged: (value) {
                        setState(() {
                          newPerangkat.perangkat = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.type,
                      labelText: 'Type',
                      icon: Icons.type_specimen_outlined,
                      onChanged: (value) {
                        newPerangkat.type = value;
                      },
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Type unit tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == placeholderRuangan) {
                          return 'Silakan pilih ruangan';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        label: Text('Ruangan'),
                      ),
                      value: widget.ruangan,
                      items: ruangan.map((e) {
                        return DropdownMenuItem<String>(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropDownChanged = true;
                          newPerangkat.ruangan = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      focusNode: focusNode,
                      textController: newPerangkat.keterangan,
                      labelText: 'Keterangan',
                      icon: Icons.more,
                      onChanged: (value) {
                        newPerangkat.keterangan = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextButtonNoIcon(
                      buttonPadding: 15,
                      hasOutline: false,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
                          focusNode.unfocus();
                          if (!dropDownChanged) {
                            newPerangkat.ruangan = widget.ruangan;
                          }

                          var route = MaterialPageRoute(
                            builder: (BuildContext context) => AddDeviceResult(
                              newPerangkat: newPerangkat,
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
