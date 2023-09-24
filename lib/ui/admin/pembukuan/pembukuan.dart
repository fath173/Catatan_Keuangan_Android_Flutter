// ignore_for_file: non_constant_identifier_names, avoid_print, void_checks, prefer_typing_uninitialized_variables, unused_local_variable, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/getAllCatatan.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:intl/intl.dart';

class PembukuanPage extends StatefulWidget {
  const PembukuanPage({super.key});

  @override
  State<PembukuanPage> createState() => _PembukuanPageState();
}

class _PembukuanPageState extends State<PembukuanPage> {
  String id_user = '';
  String token = '';

  List<DataAllCatatan> dataAllCatatan = [];

  @override
  void initState() {
    super.initState();
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  Future getByAllCatatan() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiCatatanByIdUser(id_user, token).then(
        (hasil) => {
          dataAllCatatan = [],
          hasil.data!.forEach(
            (element) {
              dataAllCatatan.add(element);
            },
          ),
        },
      );
    } catch (e) {
      print('terjadi kesalahan harian');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext baseContext) {
    id_user = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Catatan'),
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
                        FutureBuilder(
                            future: getByAllCatatan(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                    // height: (MediaQuery.of(context).size.height),
                                    height: 500,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              } else {
                                if (dataAllCatatan.isEmpty) {
                                  return const Text(
                                      'Hari ini belum ada catatan',
                                      style: TextStyle(fontSize: 16));
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(label: Text('Tanggal')),
                                      DataColumn(label: Text('Kategori')),
                                      DataColumn(label: Text('Jumlah')),
                                      DataColumn(label: Text('Keterangan')),
                                    ],
                                    rows: dataAllCatatan
                                        .map((e) => DataRow(cells: [
                                              DataCell(Text(formatTanggal(
                                                  e.tanggal.toString(),
                                                  'lengkap'))),
                                              DataCell(Text(
                                                  e.nama_kategori.toString())),
                                              DataCell(Text('Rp. ' +
                                                  e.jumlah.toString())),
                                              DataCell(Text(
                                                  e.keterangan.toString())),
                                            ]))
                                        .toList(),
                                  ),
                                );
                              }
                            }),
                      ]),
                ),
              ),
            ]),
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
      sTanggal = DateFormat('dd MMM yyyy').format(tempDate);
    }

    return sTanggal;
  }
}
