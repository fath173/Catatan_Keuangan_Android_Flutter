// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/Kategori.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:intl/intl.dart';

class CatatanTambah extends StatefulWidget {
  const CatatanTambah({super.key});

  @override
  State<CatatanTambah> createState() => _CatatanTambahState();
}

class _CatatanTambahState extends State<CatatanTambah> {
  TextEditingController txtTanggal = TextEditingController();
  final TextEditingController txtJumlah = TextEditingController();
  final TextEditingController txtKeterangan = TextEditingController();
  String kategoriPilihan = '';

  String id_user = '';
  String token = '';
  List<DataKategori> dataKategori = [];
  String errorMsgInput = '';
  String errorValidasi = '';

  int tahun_ini = 0; // tahun sekarang
  int tahun_15 = 0; //15 tahun kemarin

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);

    getDataKategori();
  }

  Future getDataKategori() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiKategori(token).then(
        (hasil) => {
          tahun_ini = int.parse(DateFormat('yyyy').format(DateTime.now())),
          tahun_15 = tahun_ini - 15,
          kategoriPilihan = '',
          kategoriPilihan = hasil.data![0].id.toString(),
          dataKategori = [],
          hasil.data!.forEach(
            (element) {
              dataKategori.add(element);
            },
          ),
        },
      );
      setState(() {});
    } catch (e) {
      print('terjadi kesalahan');
      print(e.toString());
    }
  }

  List<DropdownMenuItem> buatItemKategori(List<DataKategori> kategori) {
    List<DropdownMenuItem> items = [];
    for (var i in kategori) {
      items.add(DropdownMenuItem(
        value: i.id.toString(),
        child: Text(i.nama_kategori!),
      ));
    }
    return items;
  }

  Future validasiForm() async {
    if (txtTanggal.text == '') {
      errorValidasi = 'Tanggal tidak boleh kosong';
      return 0;
    }
    if (txtJumlah.text == '') {
      errorValidasi = 'Jumlah tidak boleh kosong';
      return 0;
    }
    if (txtKeterangan.text == '') {
      errorValidasi = 'Keterangan tidak boleh kosong';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  Future tambahCatatan() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Tambah Catatan..'),
          content: Text('Mohon menunggu! Tambah Catatan sedang diproses...'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.postApiAddNote(id_user, kategoriPilihan, txtTanggal.text,
              txtJumlah.text, txtKeterangan.text, token)
          .then(
        (hasil) => {
          if (hasil.message == 'success')
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/landing', (Route<dynamic> route) => false),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        centerTitle: mounted,
        flexibleSpace: Container(
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
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                      ),
                    ),
                    items: buatItemKategori(dataKategori),
                    isExpanded: true,
                    hint: Text('Pilih Kategori'),
                    value: kategoriPilihan,
                    onChanged: (item) {
                      setState(() {
                        kategoriPilihan = item;
                        print(kategoriPilihan);
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    controller: txtTanggal,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tanggal',
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(tahun_15),
                          lastDate: DateTime(2025),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.purple, // <-- SEE HERE
                                  onPrimary: Colors.white, // <-- SEE HERE
                                  onSurface: Colors.black, // <-- SEE HERE
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Colors.pink, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          });

                      if (pickDate == null) return;

                      String date = DateFormat('yyyy-MM-dd').format(pickDate);

                      setState(() {
                        txtTanggal.text = date;
                        print(date);
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                      controller: txtJumlah,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jumlah',
                        hintText: 'Contoh: 457000',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    controller: txtKeterangan,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Keterangan',
                      hintText: 'Tulis Keterangan Catatan..',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: const Color(0xFF9C27B0), // background
                    ),
                    child: const Text(
                      'SIMPAN',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      validasiForm();
                      errorMsgInput = '';
                      (errorValidasi == '')
                          ? tambahCatatan()
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cek Inputan Form')),
                            );
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  child: Column(children: [
                    Text(
                      (errorMsgInput == '') ? '' : 'Error: $errorMsgInput',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text((errorValidasi == '') ? '' : errorValidasi),
                  ]),
                ),
              ])),
        ),
      ),
    );
  }
}
