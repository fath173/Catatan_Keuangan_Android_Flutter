// ignore_for_file: sort_child_properties_last, unnecessary_null_comparison, unrelated_type_equality_checks, unnecessary_this, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/getByBulanan.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:intl/intl.dart';

class BulananUi extends StatefulWidget {
  const BulananUi({super.key});

  @override
  State<BulananUi> createState() => _BulananUiState();
}

class _BulananUiState extends State<BulananUi> {
  String id_user = '';
  String token = '';
  List<String> tahun = [];
  List<Bulan> bulan = [
    Bulan(angka: '01', huruf: 'Januari'),
    Bulan(angka: '02', huruf: 'Februari'),
    Bulan(angka: '03', huruf: 'Maret'),
    Bulan(angka: '04', huruf: 'April'),
    Bulan(angka: '05', huruf: 'Mei'),
    Bulan(angka: '06', huruf: 'Juni'),
    Bulan(angka: '07', huruf: 'Juli'),
    Bulan(angka: '08', huruf: 'Agustus'),
    Bulan(angka: '09', huruf: 'September'),
    Bulan(angka: '10', huruf: 'Oktober'),
    Bulan(angka: '11', huruf: 'November'),
    Bulan(angka: '12', huruf: 'Desember'),
  ];

  String bulanPilihan = '';
  String tahunPilihan = '';
  String pemasukan = '';
  String pengeluaran = '';
  String totalBersih = '';
  List<TopPemasukan> dataTopPemasukan = [];
  List<TopPengeluaran> dataTopPengeluaran = [];

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  List<DropdownMenuItem> buatItemTahun(List<String> tahun) {
    List<DropdownMenuItem> items = [];
    for (var i in tahun) {
      items.add(DropdownMenuItem(
        child: Text(i),
        value: i,
      ));
    }
    return items;
  }

  List<DropdownMenuItem> buatItemBulan(List<Bulan> bulan) {
    List<DropdownMenuItem> items = [];
    for (var i in bulan) {
      items.add(DropdownMenuItem(
        child: Text(i.huruf),
        value: i.angka,
      ));
    }
    return items;
  }

  Future getYears() async {
    await Future.delayed(const Duration(milliseconds: 500));
    String years = DateFormat('yyyy').format(DateTime.now());
    tahun = [];
    var year;
    for (var i = 0; i < 50; i++) {
      var hasil = (year == null) ? year = int.parse(years) : year -= 1;
      tahun.add(hasil.toString());
    }
  }

  Future getDataBulanan() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (bulanPilihan == '' || tahunPilihan == '') {
        bulanPilihan = DateFormat('MM').format(DateTime.now());
        tahunPilihan = DateFormat('yyyy').format(DateTime.now());
      }
      await ApiStatic.getApiByBulanan(
              id_user, bulanPilihan, tahunPilihan, token)
          .then(
        (hasil) => {
          pemasukan = '',
          pengeluaran = '',
          totalBersih = '',
          pemasukan = hasil.pemasukan.toString(),
          pengeluaran = hasil.pengeluaran.toString(),
          totalBersih = hasil.total_bersih.toString(),
          // sava top pemasukan to array
          dataTopPemasukan = [],
          hasil.topPemasukan!.forEach(
            (element) {
              dataTopPemasukan.add(element);
            },
          ),
          // sava top pengeluaran to array
          dataTopPengeluaran = [],
          hasil.topPengeluaran!.forEach(
            (element) {
              dataTopPengeluaran.add(element);
            },
          ),
        },
      );
    } catch (e) {
      print('terjadi kesalahan bulanan');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: getYears(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                          child: const Text(''));
                    } else {
                      return Card(
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: DropdownButton(
                                  items: buatItemBulan(bulan),
                                  // isExpanded: true,
                                  hint: Text('Pilih Bulan'),
                                  value: bulanPilihan,
                                  onChanged: (item) {
                                    setState(() {
                                      bulanPilihan = item;
                                      getDataBulanan();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: DropdownButton(
                                  items: buatItemTahun(tahun),
                                  // isExpanded: true,
                                  hint: const Text('Pilih Tahun'),
                                  value: tahunPilihan,
                                  onChanged: (item) {
                                    setState(() {
                                      tahunPilihan = item;
                                      getDataBulanan();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
              Container(
                child: FutureBuilder(
                    future: getDataBulanan(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            // height: (MediaQuery.of(context).size.height),
                            height: 500,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        return Column(
                          children: [
                            Card(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 20),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Pemasukan',
                                              style: TextStyle(fontSize: 16)),
                                          Text('Rp. $pemasukan',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Pengeluaran',
                                              style: TextStyle(fontSize: 16)),
                                          Text('Rp. $pengeluaran',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      child: Divider(color: Colors.black),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Bersih',
                                              style: TextStyle(fontSize: 16)),
                                          Text('Rp. $totalBersih',
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 20),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Top Kategori Pengeluaran',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        shrinkWrap: true,
                                        itemCount: dataTopPengeluaran.length,
                                        itemBuilder: ((context, index) =>
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 10, 30, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '${dataTopPengeluaran[index].keterangan}',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                  Text(
                                                      'Rp. ${dataTopPengeluaran[index].jumlah}',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Top Kategori Pemasukan',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        shrinkWrap: true,
                                        itemCount: dataTopPemasukan.length,
                                        itemBuilder: ((context, index) =>
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 10, 30, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '${dataTopPemasukan[index].keterangan}',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                  Text(
                                                      'Rp. ${dataTopPemasukan[index].jumlah}',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }), //column
              ), //contatiner
            ],
          ),
          //futurebuiklder
        ),
      ),
    );
  }
}

class Bulan {
  String angka;
  String huruf;
  Bulan({required this.angka, required this.huruf});
}
