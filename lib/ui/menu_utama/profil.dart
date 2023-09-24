// ignore_for_file: unused_element, non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/AkunSaya.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/profil/akunImage.dart';

class ProfilUser extends StatelessWidget {
  const ProfilUser({super.key});
  @override
  Widget build(BuildContext baseContext) {
    String serverUrl = '';
    String id_user = '';
    String token = '';

    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
    serverUrl = ApiStatic.urlServer; //for image

    List<DataAkun> dataUser = [];

    Future getDataAkun() async {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        await ApiStatic.getApiMyAkun(id_user, token).then(
          (hasil) => {
            dataUser = [],
            hasil.data!.forEach(
              (element) {
                dataUser.add(element);
              },
            ),
          },
        );
        print(token);
      } catch (e) {
        print('terjadi kesalahan profile');
        print(e.toString());
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getDataAkun(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 500,
                      child: const Center(child: CircularProgressIndicator()));
                } else {
                  return Column(
                    children: [
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Column(children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Nama',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${dataUser[0].name}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Alamat',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${dataUser[0].alamat}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${dataUser[0].email}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Column(children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Telepon',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${dataUser[0].telepon}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                          child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                color: Colors.purple,
                                width: 150,
                                height: 200,
                                padding: const EdgeInsets.all(3),
                                child: Image(
                                  image: NetworkImage((dataUser[0].foto != null)
                                      ? "http://$serverUrl/images/profile/${dataUser[0].foto}"
                                      : "http://$serverUrl/images/profile/user.png"),
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.repeat,
                                ),
                              ),
                              Container(
                                child: Column(children: [
                                  SizedBox(
                                    width: 90,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Colors.white, // foreground
                                        backgroundColor:
                                            Colors.purple, // background
                                      ),
                                      onPressed: () {
                                        Navigator.of(baseContext)
                                            .pushNamed('/akunEdit');
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Colors.white, // foreground
                                        backgroundColor:
                                            Colors.pink.shade600, // background
                                      ),
                                      onPressed: () {
                                        // Navigator.pushReplacement(baseContext,
                                        //     MaterialPageRoute(
                                        //         builder: (context) {
                                        //   return const AkunImage();
                                        // }));
                                        Navigator.of(baseContext)
                                            .pushNamed('/akunImage');
                                      },
                                      child: const Text('Foto'),
                                    ),
                                  ),
                                ]),
                              ),
                            ]),
                      )),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
