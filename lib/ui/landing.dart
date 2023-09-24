// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/menu_utama/bulanan.dart';
import 'package:flutter_pembukuan/ui/menu_utama/harian.dart';
import 'package:flutter_pembukuan/ui/menu_utama/profil.dart';

class LandingPage extends StatefulWidget {
  final int pilihPage;

  const LandingPage({Key? key, required this.pilihPage}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState(pilihPage);
}

class _LandingPageState extends State<LandingPage> {
  int pageDipiih;
  _LandingPageState(this.pageDipiih);

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
    TabBar myTabBar = const TabBar(
        labelColor: Colors.white, // active
        unselectedLabelColor: Colors.white60, // non active
        indicator: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.white, width: 3))),
        labelStyle: TextStyle(fontSize: 16),
        tabs: [
          Tab(text: 'Harian'),
          Tab(text: 'Laporan'), // ini adalah tabbed bar
          Tab(text: 'Profil'),
        ]);

    // style app bar gradasi
    var appBarGradasi = AppBar(
      // toolbarHeight: 70,
      centerTitle: true,
      leading: const Icon(Icons.ac_unit),
      title: const Text(
        'Catatan Keuangan',
        style: TextStyle(color: Colors.white),
      ),
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
                    ));
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.verified_user),
        //   onPressed: () {
        //     SharedLogin.getIdUser().then((v) => print("id:$v"));
        //     SharedLogin.getRole().then((v) => print("Role:$v"));
        //     SharedLogin.getEmailVerified().then((v) => print("Verified:$v"));
        //     SharedLogin.getToken().then((v) => print("Token:$v"));
        //   },
        // ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(233, 30, 99, 1),
              Color.fromRGBO(156, 39, 176, 1)
            ],
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
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(myTabBar.preferredSize.height),
          child: Container(color: Colors.transparent, child: myTabBar)),
    );

    return DefaultTabController(
      initialIndex: pageDipiih,
      length: 3,
      child: Scaffold(
        appBar: appBarGradasi,
        body: FutureBuilder(
            future: getVerified(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                    child: const Text(''));
              } else {
                if (emailVerified != 'null') {
                  return const TabBarView(children: [
                    HarianUi(),
                    BulananUi(),
                    ProfilUser(),
                  ]);
                } else {
                  return const TabBarView(children: [
                    Center(
                      child:
                          Text('Konfirmasi pada email anda dan login ulang!'),
                    ),
                    Center(
                      child:
                          Text('Konfirmasi pada email anda dan login ulang!'),
                    ),
                    Center(
                      child:
                          Text('Konfirmasi pada email anda dan login ulang!'),
                    ),
                  ]);
                }
              }
            }),
      ),
    );
  }
}
