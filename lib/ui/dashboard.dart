import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  String emailVerified = '';
  String idUser = '';
  String token = '';

  Future getVerified() async {
    SharedLogin.getEmailVerified().then((v) => emailVerified = v);
    SharedLogin.getIdUser().then((v) => idUser = v.toString());
    SharedLogin.getToken().then((v) => token = v);
  }

  Future getLogout() async {
    try {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Logout..'),
          content: Text('Mohon menunggu! Logout Aplikasi sedang diproses...'),
        ),
      );
      await ApiStatic.getApiLogout(idUser, token).then((v) => {
            if (v.message == 'You are Logout.')
              {
                SharedLogin.removeSharedPref(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/launcher', (Route<dynamic> route) => false)
              }
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getVerified();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // title: const Text('Dashboard'),
          leading: const Icon(Icons.ac_unit),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout!'),
                    content: const Text('Apakah anda yakin?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal')),
                      TextButton(
                          onPressed: () {
                            getLogout();
                          },
                          child: const Text('YA')),
                    ],
                  ),
                );
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
          child: Container(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              // singlechild ini hanya di column/row
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 140, 0, 70),
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      children: const [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Dashboard',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Selamat datang admin.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: const Color.fromRGBO(254, 241, 255, 0.5),
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 3,
                                    child: InkWell(
                                      highlightColor:
                                          Colors.purple.withOpacity(0.3),
                                      splashColor: Colors.pink.withOpacity(0.5),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/category');
                                      },
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.5),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 20, 5, 10),
                                              child: const Image(
                                                image: AssetImage(
                                                    "assets/icons/category.png"),
                                                fit: BoxFit.contain,
                                                // repeat: ImageRepeat.repeat,
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Text(
                                                'Kategori',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 3,
                                    child: InkWell(
                                      highlightColor:
                                          Colors.purple.withOpacity(0.3),
                                      splashColor: Colors.pink.withOpacity(0.5),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/allUserNote');
                                      },
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.5),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 20, 5, 10),
                                              child: const Image(
                                                image: AssetImage(
                                                    "assets/icons/note.png"),
                                                fit: BoxFit.contain,
                                                // repeat: ImageRepeat.repeat,
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Text(
                                                'Pembukuan',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
