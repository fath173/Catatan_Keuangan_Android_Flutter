// ignore_for_file: avoid_unnecessary_containers, unrelated_type_equality_checks, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtPasswordConfirm = TextEditingController();

  String message = '';
  String dataErrors = '';
  String csrfToken = '';
  String errorValidasi = '';
  String _errorValidasiEmail = '';

  @override
  void initState() {
    super.initState();
    ApiStatic.getWebCsrfToken().then((v) => {csrfToken = v.csrf!});
  }

  _registerUser() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Registrasi..'),
          content: Text('Mohon menunggu! Registrasi sedang diproses...'),
        ),
      );
      ApiStatic.getApiRegister(
        txtName.text,
        txtEmail.text,
        txtPassword.text,
        txtPasswordConfirm.text,
        csrfToken,
      ).then((hasil) => {
            if (hasil.message == 'success')
              {
                message = '',
                message = hasil.message!,
                dataErrors = '',
                dataErrors = hasil.errors!,
                setState(() {}),
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false,
                    arguments: 'registered'),
              }
            else
              {
                message = '',
                message = hasil.message!,
                dataErrors = '',
                dataErrors = hasil.errors!,
                Navigator.of(context).pop(),
                setState(() {}),
              }
          });
    } catch (e) {
      print(e);
    }
  }

  Future validasiForm() async {
    if (txtName.text == '') {
      errorValidasi = 'Nama tidak boleh kosong';
      return 0;
    }
    if (txtEmail.text == '') {
      errorValidasi = 'Email tidak boleh kosong';
      return 0;
    }
    if (txtPassword.text == '') {
      errorValidasi = 'Password tidak boleh kosong';
      return 0;
    }
    if (txtPassword.text != txtPasswordConfirm.text) {
      errorValidasi = 'Password tidak sama';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(10, 100, 10, 60),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.purple, //<-- SEE HERE
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  color: Colors.transparent,
                  // height: 500,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Column(
                    children: [
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pushNamed(context, "write your route");
                        },
                        child: const Text(
                            'Anda sudah punya akun? Login disini!',
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: TextField(
                          controller: txtName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nama',
                            hintText: 'Tulis Nama disini..',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: TextField(
                          controller: txtEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Tulis Email disini..',
                          ),
                          onChanged: (value) {
                            validateEmail(value);
                          },
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
                              (dataErrors.isNotEmpty
                                  ? dataErrors.toString()
                                  : ''),
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
                            foregroundColor: Colors.white, // foreground
                            backgroundColor: Colors.black, // background
                          ),
                          child: const Text(
                            'Registrasi',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            errorValidasi == '';
                            message = '';
                            dataErrors = '';
                            validasiForm();
                            (errorValidasi == '' && _errorValidasiEmail == '')
                                ? _registerUser()
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

  void validateEmail(String val) {
    print(val);
    if (val.isEmpty) {
      setState(() {
        _errorValidasiEmail = "Email tidak boleh kosong";
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _errorValidasiEmail = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorValidasiEmail = '';
      });
    }
    print(_errorValidasiEmail);
  }
}
