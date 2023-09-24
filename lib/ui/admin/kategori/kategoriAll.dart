import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/Kategori.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  String id_user = '';
  String token = '';
  List<DataKategori> dataKategori = [];

  String errorMsgInput = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  Future getDataKategori() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiKategori(token).then(
        (hasil) => {
          dataKategori = [],
          hasil.data!.forEach(
            (element) {
              dataKategori.add(element);
            },
          ),
        },
      );
    } catch (e) {
      print('terjadi kesalahan');
      print(e.toString());
    }
  }

  Future deleteKategori(String idKategori) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Hapus Kategori..'),
          content: Text('Mohon menunggu! Hapus Kategori sedang diproses...'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.delApiDeleteKategori(idKategori, token).then(
        (hasil) => {
          if (hasil.message == 'success')
            {
              getDataKategori(),
              Navigator.of(context).pop(),
            }
          else
            {
              errorMsgInput = hasil.message.toString(),
            }
        },
      );
      setState(() {});
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
          title: const Text('Kategori'),
          // centerTitle: mounted,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/categoryAdd');
              },
            ),
          ],
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
              future: getDataKategori(),
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
                                'Seluruh Data Kategori',
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
                                      itemCount: dataKategori.length,
                                      itemBuilder: ((context, index) =>
                                          Slidable(
                                            key: ValueKey(
                                                dataKategori[index].id),
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: ((context) {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/categoryEdit',
                                                            arguments:
                                                                dataKategori[
                                                                    index]);
                                                  }),
                                                  backgroundColor:
                                                      const Color(0xFF9C27B0),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  label: 'Edit',
                                                ),
                                                SlidableAction(
                                                  flex: 1,
                                                  onPressed: ((context) {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'Hapus Kategori!'),
                                                                  content: Text(
                                                                      'Anda akan menghapus: ${dataKategori[index].nama_kategori!.toString()}'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Batal')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          deleteKategori(dataKategori[index]
                                                                              .id
                                                                              .toString());
                                                                        },
                                                                        child: const Text(
                                                                            'YA')),
                                                                  ],
                                                                ));
                                                  }),
                                                  backgroundColor:
                                                      const Color(0xFFE91E63),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Hapus',
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              height: 50,
                                              padding: const EdgeInsets.all(10),
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
                                                      "${dataKategori[index].nama_kategori}"),
                                                  Text(
                                                      '${dataKategori[index].tipe}',
                                                      style: (dataKategori[
                                                                      index]
                                                                  .tipe ==
                                                              'pemasukan')
                                                          ? const TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 16)
                                                          : const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16)),
                                                ],
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
