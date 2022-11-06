import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';

String defaultIp = '192.168.1.100';
String defaultUrl = 'mymx.000webhostapp.com';

String url = defaultUrl;

class IPAddressPage extends StatefulWidget {
  const IPAddressPage({Key? key}) : super(key: key);

  @override
  State<IPAddressPage> createState() => _IPAddressPageState();
}

class _IPAddressPageState extends State<IPAddressPage> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  String newIPAddress = defaultIp;
  String newHostAddress = defaultUrl;

  bool useLocalhost = false;

  @override
  void initState() {
    super.initState();

    bool? useLocal = preferences.getBool('useLocal');

    if (useLocal != null) {
      useLocalhost = useLocal;
    }

    String? savedIP = preferences.getString('IP');
    if (savedIP != null) {
      newIPAddress = savedIP;
    }

    String? savedHost = preferences.getString('HOST');
    if (savedHost != null) {
      newHostAddress = savedHost;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Ubah URL',
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Text(
                      'Url saat ini',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      url,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                Center(
                  child: TextFormField(
                    focusNode: focusNode,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.add_link_outlined),
                      label: Text(useLocalhost ? 'Enter IP Address' : 'Enter url'),
                      hintText: useLocalhost ? '192.168.0.1' : 'github.com/',
                    ),
                    onChanged: (value) {
                      if (useLocalhost) {
                        newIPAddress = value;
                      } else {
                        newHostAddress = value;
                      }
                    },
                    autofocus: true,
                    keyboardType: useLocalhost ? TextInputType.phone : TextInputType.url,
                    controller: TextEditingController(text: url),
                    validator: (value) {
                      if (useLocalhost) {
                        if (value!.length > 15) {
                          return 'Alamat IP tidak valid!';
                        } else if (value.isEmpty) {
                          return 'Alamat IP tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      } else {
                        if (value!.isEmpty) {
                          return 'Alamat url tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                mxTextButton(
                  buttonPadding: 15,
                  icon: Icons.save_alt,
                  label: useLocalhost ? 'Ubah IP Address' : 'Ubah Url',
                  onPress: () {
                    final isValidForm = formKey.currentState!.validate();
                    if (isValidForm) {
                      setState(
                        () {
                          if (useLocalhost) {
                            url = newIPAddress;
                            preferences.setString('IP', newIPAddress);
                          } else {
                            url = newHostAddress;
                            preferences.setString('HOST', newHostAddress);
                          }

                          // drawerUrlText.value = url;

                          preferences.setBool('useLocal', useLocalhost);
                          preferences.setString('URL', url);

                          closeDrawer();
                          Navigator.maybePop(context);
                          if (kDebugMode) {
                            print("Url Updated to : $url");
                          }
                        },
                      );
                    }
                  },
                ),
                Flexible(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    title: const Text('Gunakan IP Address (local hosting)'),
                    trailing: Switch.adaptive(
                        value: useLocalhost,
                        onChanged: (value) {
                          setState(() {
                            useLocalhost = value;

                            focusNode.unfocus();
                            Future.delayed(const Duration(milliseconds: 500)).then((value) => focusNode.requestFocus());

                            formKey.currentState!.reset();
                          });
                        }),
                  ),
                ),
                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
