import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';

String iPAddress = '192.168.221.221';

class IPAddressPage extends StatefulWidget {
  const IPAddressPage({Key? key}) : super(key: key);

  @override
  State<IPAddressPage> createState() => _IPAddressPageState();
}

class _IPAddressPageState extends State<IPAddressPage> {
  final formKey = GlobalKey<FormState>();

  String newAddress = iPAddress;

  @override
  void initState() {
    super.initState();

    String? ip = preferences.getString('IP');
    if (ip == null) {
      newAddress = iPAddress;
      return;
    }
    setState(() {
      newAddress = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'IP Address',
        leading: Builder(
          builder: ((context) {
            return IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            );
          }),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'IP saat ini',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      iPAddress,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75),
              Center(
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wifi),
                    label: Text('Enter IP Address'),
                    hintText: '0.0.0.0',
                  ),
                  onChanged: (value) {
                    newAddress = value;
                  },
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  controller: TextEditingController(text: iPAddress),
                  validator: (value) {
                    if (value!.length > 15) {
                      return 'Alamat IP tidak valid!';
                    } else if (value.isEmpty) {
                      return 'Alamat IP tidak boleh kosong!';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              mxTextButton(
                buttonPadding: 10,
                icon: Icons.save_alt,
                label: 'Ubah IP Address',
                labelFontSize: 14,
                onPress: () {
                  final isValidForm = formKey.currentState!.validate();
                  if (isValidForm) {
                    setState(
                      () {
                        iPAddress = newAddress;
                        preferences.setString('IP', newAddress);
                        closeDrawer();
                        Navigator.maybePop(context);
                        if (kDebugMode) {
                          print("IP Updated to : $newAddress");
                        }
                      },
                    );
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
