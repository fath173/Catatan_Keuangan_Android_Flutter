// ignore_for_file: non_constant_identifier_names, avoid_print, void_checks, prefer_typing_uninitialized_variables, unused_local_variable, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/getByTanggal.dart';
import 'package:flutter_pembukuan/model/getByHarian.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/catatan/catatanDetailDate.dart';
import 'package:intl/intl.dart';

class HarianUi extends StatefulWidget {
  const HarianUi({super.key});

  @override
  State<HarianUi> createState() => _HarianUiState();
}

class _HarianUiState extends State<HarianUi> {
  String id_user = '';
  String token = '';
  String tanggal = '';

  List<DataByTanggal> dataByTanggal = [];
  List<DataHarian> dataHarian = [];

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
    tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future getByTanggal() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiByTanggal(id_user, tanggal, token).then(
        (hasil) => {
          dataByTanggal = [],
          hasil.data!.forEach(
            (element) {
              dataByTanggal.add(element);
            },
          ),
        },
      );
    } catch (e) {
      print('terjadi kesalahan harian');
      print(e.toString());
    }
  }

  Future getDataHarian() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiHarian(id_user, token).then(
        (hasil) => {
          dataHarian = [],
          hasil.data!.forEach(
            (element) {
              dataHarian.add(element);
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
  Widget build(BuildContext baseContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          child: Scrollbar(
            child: SingleChildScrollView(
              // physics: ,
              child: Column(children: [
                Card(
                  child: Container(
                    width: double.infinity,
                    // height: 50,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Scrollbar(
                            child: Container(
                              constraints: const BoxConstraints(
                                  minHeight: 100, maxHeight: 300),
                              child: FutureBuilder(
                                  future: getByTanggal(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      if (dataByTanggal.isEmpty) {
                                        return const Text(
                                            'Hari ini belum ada catatan',
                                            style: TextStyle(fontSize: 16));
                                      }
                                      return ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        shrinkWrap: true,
                                        itemCount: dataByTanggal.length,
                                        itemBuilder: ((context, index) =>
                                            Container(
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
                                                    "${dataByTanggal[index].keterangan}",
                                                    style: (dataByTanggal[index]
                                                                .tipe ==
                                                            'pemasukan')
                                                        ? const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 16)
                                                        : const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                  ),
                                                  Text(
                                                    'Rp. ${dataByTanggal[index].jumlah.toString()}',
                                                    style: (dataByTanggal[index]
                                                                .tipe ==
                                                            'pemasukan')
                                                        ? const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 16)
                                                        : const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: const Color(0xFF9C27B0), // background
                    ),
                    onPressed: () {
                      Navigator.of(baseContext).pushNamed('/noteAdd');
                    },
                    label: const Text('TAMBAH'),
                    icon: const Icon(Icons.note_add),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 60),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Scrollbar(
                      child: Container(
                        constraints: const BoxConstraints(
                            minHeight: 100, maxHeight: 500),
                        child: FutureBuilder(
                          future: getDataHarian(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: dataHarian.length,
                                itemBuilder: ((context, index) =>
                                    Column(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Material(
                                          child: InkWell(
                                            highlightColor:
                                                Colors.purple.withOpacity(0.3),
                                            splashColor:
                                                Colors.pink.withOpacity(0.5),
                                            onTap: () {
                                              setState(() {});
                                              String kdate = dataHarian[index]
                                                  .tanggal
                                                  .toString();
                                              Navigator.push(baseContext,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return CatatanDetail(
                                                    date: kdate);
                                              }));
                                            },
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                minHeight: 70,
                                                maxHeight: 110,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      width: 100,
                                                      // height: doub,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      color:
                                                          const Color.fromRGBO(
                                                              214,
                                                              214,
                                                              214,
                                                              0.5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(formatTanggal(
                                                              dataHarian[index]
                                                                  .tanggal
                                                                  .toString(),
                                                              'hari')),
                                                          Text(formatTanggal(
                                                              dataHarian[index]
                                                                  .tanggal
                                                                  .toString(),
                                                              'bulan')),
                                                          Text(formatTanggal(
                                                              dataHarian[index]
                                                                  .tanggal
                                                                  .toString(),
                                                              'tahun')),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      // height: 70,
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 10, 10, 10),
                                                      color:
                                                          const Color.fromRGBO(
                                                              238,
                                                              238,
                                                              238,
                                                              0.5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Pemasukan  :    Rp. ${dataHarian[index].pemasukan}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                              'Pengeluaran :    Rp. ${dataHarian[index].pengeluaran}',
                                                              // ignore: prefer_const_constructors
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                      ),
                                    ])),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  formatTanggal(String tanggal, String pilihan) {
    var sTanggal;
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(tanggal);

    if (pilihan == 'tahun') {
      sTanggal = DateFormat('yyyy').format(tempDate);
    } else if (pilihan == 'bulan') {
      sTanggal = DateFormat('MMMM').format(tempDate);
    } else if (pilihan == 'hari') {
      sTanggal = DateFormat('dd').format(tempDate);
    } else {
      sTanggal = DateFormat('yyyy MMMM dd').format(tempDate);
    }

    return sTanggal;
  }
}
