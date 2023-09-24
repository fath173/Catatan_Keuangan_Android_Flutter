// ignore_for_file: avoid_unnecessary_containers, unused_element

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  String message = '';
  String msgRegisterForgotPass = '';

  String errorValidasi = '';
  String _errorValidasiEmail = '';

  @override
  void initState() {
    super.initState();
  }

  Future validasiForm() async {
    if (txtEmail.text == '') {
      errorValidasi = 'Email tidak boleh kosong';
      return 0;
    }
    if (txtPassword.text == '') {
      errorValidasi = 'Password tidak boleh kosong';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  _cekLogin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Proses Login..'),
        content: Text('Mohon menunggu! Login sedang diproses...'),
      ),
    );
    try {
      ApiStatic.getApiLogin(txtEmail.text, txtPassword.text).then((v) => {
            if (v.message == 'success')
              {
                SharedLogin.saveSharedPref(
                    v.id, v.role, v.email_verified_at, v.token),
                Navigator.of(context).pop(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/launcher', (Route<dynamic> route) => false),
              }
            else
              {
                message = '',
                message = v.message,
                setState(() {}),
                Navigator.of(context).pop(),
              }
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    msgRegisterForgotPass =
        ModalRoute.of(context)!.settings.arguments.toString();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(10, 150, 10, 60),
                // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.purple, //<-- SEE HERE
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                    child: Column(
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Silahkan Login untuk Melanjutkan!',
                          style: TextStyle(fontSize: 15),
                        ),
                        Column(children: [
                          Text(
                              (msgRegisterForgotPass == 'registered')
                                  ? 'Berhasil Registrasi! Silahkan Konfirmasi Pada Email Anda!'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.red)),
                          Text(
                              (msgRegisterForgotPass ==
                                      'We have emailed your password reset link!')
                                  ? 'Sukses Kirim Link Reset Password ke Email Anda!'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.red)),
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                          child: TextField(
                            controller: txtEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Tulis Email anda disini..',
                            ),
                            onChanged: (value) {
                              validateEmail(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: TextField(
                            controller: txtPassword,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Tulis Password anda disini..',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            child: Column(
                          children: [
                            Text((message != '') ? message : '',
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
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, // foreground
                              backgroundColor: Colors.black, // background
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              _errorValidasiEmail = '';
                              errorValidasi == '';
                              message = '';
                              validasiForm();
                              (errorValidasi == '' && _errorValidasiEmail == '')
                                  ? _cekLogin()
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Cek Inputan Form')),
                                    );

                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/forgotPassword');
                          },
                          child: const Text('Lupa Password?',
                              style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                            child: const Text('Registrasi!',
                                style: TextStyle(fontSize: 16))),
                        const SizedBox(height: 30),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateEmail(String val) {
    message = '';
    errorValidasi = '';
    if (val.isEmpty) {
      setState(() {
        _errorValidasiEmail = "Email tidak boleh kosong";
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _errorValidasiEmail = "Penulisan Email Salah";
      });
    } else {
      setState(() {
        _errorValidasiEmail = '';
      });
    }
    print(_errorValidasiEmail);
  }
}
