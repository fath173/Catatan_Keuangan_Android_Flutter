// ignore_for_file: avoid_unnecessary_containers

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final TextEditingController txtEmail = TextEditingController();

  String message = '';
  String csrfToken = '';
  String errorValidasi = '';
  String _errorValidasiEmail = '';

  @override
  void initState() {
    super.initState();
    ApiStatic.getWebCsrfToken().then((v) => {csrfToken = v.csrf!});
  }

  _sendForgotPassword() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Kirim Link ke Email..'),
          content: Text(
              'Mohon menunggu! Link reset password sedang proses kirim ke email anda...'),
        ),
      );
      ApiStatic.getApiForgotPassword(txtEmail.text, csrfToken).then((hasil) => {
            if (hasil.message == 'We have emailed your password reset link!')
              {
                message = '',
                message = hasil.message!,
                setState(() {}),
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false,
                    arguments: message),
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
    if (txtEmail.text == '') {
      errorValidasi = 'Email tidak boleh kosong ges';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  margin: const EdgeInsets.fromLTRB(10, 220, 10, 60),
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
                          'Lupa Password',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Kirim link reset password ke email anda.'),
                        const SizedBox(height: 20),
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
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, // foreground
                              backgroundColor: Colors.black, // background
                            ),
                            child: const Text(
                              'Kirim',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              // print(csrfToken);

                              errorValidasi == '';
                              message = '';
                              validasiForm();
                              (errorValidasi == '' && _errorValidasiEmail == '')
                                  ? _sendForgotPassword()
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
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, "write your route");
                          },
                          child: const Text('Login? Klik disini!',
                              style: TextStyle(fontSize: 16)),
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
      ),
    );
  }

  void validateEmail(String val) {
    errorValidasi = '';
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
  }
}
