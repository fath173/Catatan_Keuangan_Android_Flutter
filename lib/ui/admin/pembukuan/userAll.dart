import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/pengguna.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/admin/pembukuan/pembukuan.dart';

class PembukuanUser extends StatefulWidget {
  const PembukuanUser({super.key});

  @override
  State<PembukuanUser> createState() => _PembukuanUserState();
}

class _PembukuanUserState extends State<PembukuanUser> {
  String id_user = '';
  String token = '';
  List<DataPengguna> dataPengguna = [];

  String errorMsgInput = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  Future getDataAllUser() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getAllUser(token).then(
        (hasil) => {
          dataPengguna = [],
          hasil.data!.forEach(
            (element) {
              dataPengguna.add(element);
            },
          ),
        },
      );
    } catch (e) {
      print('terjadi kesalahan');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        // auto muncul tmobol back harus tanpa materialApp()
        appBar: AppBar(
          title: const Text('Pembukuan'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
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
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getDataAllUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      // height: (MediaQuery.of(context).size.height),
                      height: 500,
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: const Center(
                                  child: Text(
                                'Seluruh Data Pengguna',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ))),
                        ),
                        Card(
                          child: Container(
                            // height: (MediaQuery.of(context).size.height),
                            width: (MediaQuery.of(context).size.width),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((errorMsgInput == '')
                                      ? ''
                                      : errorMsgInput),
                                  Container(
                                    constraints: const BoxConstraints(
                                        minHeight: 100,
                                        maxHeight: double.infinity),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      shrinkWrap: true,
                                      itemCount: dataPengguna.length,
                                      itemBuilder: ((context, index) =>
                                          Material(
                                            child: InkWell(
                                              highlightColor: Colors.purple
                                                  .withOpacity(0.3),
                                              splashColor:
                                                  Colors.pink.withOpacity(0.5),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/allNote',
                                                    arguments:
                                                        dataPengguna[index]
                                                            .id
                                                            .toString());
                                              },
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${dataPengguna[index].name}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
