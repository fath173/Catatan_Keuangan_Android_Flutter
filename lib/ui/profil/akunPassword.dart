// ignore_for_file: avoid_unnecessary_containers, unrelated_type_equality_checks, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:email_validator/email_validator.dart';

class AkunPassword extends StatefulWidget {
  const AkunPassword({super.key});

  @override
  State<AkunPassword> createState() => _AkunPasswordState();
}

class _AkunPasswordState extends State<AkunPassword> {
  final TextEditingController txtPasswordOld = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtPasswordConfirm = TextEditingController();

  String id_user = '';
  String token = '';

  String message = '';
  String errorValidasi = '';
  String _errorValidasiEmail = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  ubahPassword() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Registrasi..'),
          content: Text('Mohon menunggu! Registrasi sedang diproses...'),
        ),
      );
      ApiStatic.putApiUpdatePassword(
        id_user,
        txtPasswordOld.text,
        txtPassword.text,
        txtPasswordConfirm.text,
        token,
      ).then((hasil) => {
            if (hasil.message == 'success')
              {
                message = '',
                message = hasil.message!,
                Navigator.of(context).pop(),
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                      });
                      return const AlertDialog(
                        title: Text('Berhasil Update!',
                            style: TextStyle(color: Colors.green)),
                      );
                    }),
              }
            else
              {
                message = '',
                message = hasil.message!,
                Navigator.of(context).pop(),
                setState(() {}),
              }
          });
    } catch (e) {
      print(e);
    }
  }

  Future validasiForm() async {
    if (txtPasswordOld.text == '') {
      errorValidasi = 'Password tidak boleh kosong';
      return 0;
    }

    if (txtPassword.text == '') {
      errorValidasi = 'Password tidak boleh kosong';
      return 0;
    }

    if (txtPassword.text != txtPasswordConfirm.text) {
      errorValidasi = 'Password Konfirmasi tidak sama';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Password'),
        // centerTitle: mounted,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
            ),
            image: DecorationImage(
              image: AssetImage('assets/appbar/pattern.png'),
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 60),
                color: Colors.white,
                child: Container(
                  color: Colors.transparent,
                  // height: 500,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: TextField(
                          controller: txtPasswordOld,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Pasword Lama',
                            hintText: 'Tulis Pasword Lama disini..',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: TextField(
                          controller: txtPassword,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Tulis Password..',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: TextField(
                          controller: txtPasswordConfirm,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Konfirmasi Password',
                            hintText: 'Tulis Ulang Password..',
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Container(
                          child: Column(
                        children: [
                          Text((message != '' ? message : ''),
                              style: const TextStyle(color: Colors.red)),
                          Text(
                            (errorValidasi == '' ? '' : errorValidasi),
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            (_errorValidasiEmail == ''
                                ? ''
                                : _errorValidasiEmail),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                      // const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF9C27B0),
                          ),
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            errorValidasi == '';
                            message = '';

                            validasiForm();
                            (errorValidasi == '' && _errorValidasiEmail == '')
                                ? ubahPassword()
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Cek Inputan Form')),
                                  );
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
