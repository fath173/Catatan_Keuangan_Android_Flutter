// ignore_for_file: non_constant_identifier_names, must_be_immutable, no_logic_in_create_state, unnecessary_cast

import 'package:flutter/material.dart';

import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/getByTanggal.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class CatatanDetail extends StatefulWidget {
  final String date;

  const CatatanDetail({Key? key, required this.date}) : super(key: key);
  @override
  State<CatatanDetail> createState() => _CatatanDetailState(date);
}

class _CatatanDetailState extends State<CatatanDetail> {
  String tanggalCatatan;
  _CatatanDetailState(this.tanggalCatatan);

  String id_user = '';
  String token = '';

  List<DataByTanggal> dataByTanggal = [];
  String dPemasukan = '';
  String dPengeluaran = '';
  String errorMsgInput = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  Future getByTanggal() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiByTanggal(id_user, tanggalCatatan, token).then(
        (hasil) => {
          if (hasil.data!.isEmpty)
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/landing', (Route<dynamic> route) => false)
            },
          dPemasukan = '',
          dPengeluaran = '',
          dataByTanggal = [],
          dPemasukan = hasil.pemasukan.toString(),
          dPengeluaran = hasil.pengeluaran.toString(),
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

  Future deleteCatatan(String id_note, String tanggal) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Hapus Catatan..'),
          content: Text('Mohon menunggu! Hapus Catatan sedang diproses...'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.delApiDeleteNote(id_note, token).then(
        (hasil) => {
          if (hasil.message == 'success')
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return CatatanDetail(date: tanggal);
              })),
            }
          else
            {
              errorMsgInput = hasil.message.toString(),
              Navigator.of(context).pop(),
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
  Widget build(BuildContext baseContext) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/landing', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(formatTanggal(tanggalCatatan, 'default')),
            centerTitle: mounted,
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
            reverse: false,
            child: FutureBuilder(
                future: getByTanggal(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        // height: (MediaQuery.of(context).size.height),
                        height: 500,
                        child: Center(child: CircularProgressIndicator()));
                    ;
                  } else {
                    if (dataByTanggal.isEmpty) {
                      return const Text('Hari ini belum ada catatan');
                    }
                    return Card(
                      child: Container(
                        // height: (MediaQuery.of(context).size.height),
                        width: (MediaQuery.of(context).size.width),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Pemasukan  : Rp. ' + dPemasukan,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Pengeluaran : Rp. ' + dPengeluaran,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text((errorMsgInput == '') ? '' : errorMsgInput),
                              Container(
                                constraints: const BoxConstraints(
                                    minHeight: 100, maxHeight: double.infinity),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  shrinkWrap: true,
                                  itemCount: dataByTanggal.length,
                                  itemBuilder: ((context, index) => Slidable(
                                        key: ValueKey(dataByTanggal[index].id),
                                        endActionPane: ActionPane(
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: ((context) {
                                                Navigator.of(baseContext)
                                                    .pushNamed(
                                                        '/noteEdit',
                                                        arguments:
                                                            dataByTanggal[
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
                                                                  'Hapus Catatan!'),
                                                              content: const Text(
                                                                  'Apakah anda yakin?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'Batal')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      deleteCatatan(
                                                                          dataByTanggal[index]
                                                                              .id
                                                                              .toString(),
                                                                          dataByTanggal[index]
                                                                              .tanggal
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
                                                MainAxisAlignment.spaceBetween,
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
                                        ),
                                      )),
                                ),
                              ),
                            ]),
                      ),
                    );
                  }
                }),
          )),
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
      sTanggal = DateFormat('dd MMMM yyyy').format(tempDate);
    }

    return sTanggal;
  }
}
