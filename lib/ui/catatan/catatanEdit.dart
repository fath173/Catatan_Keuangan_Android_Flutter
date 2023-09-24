// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/getByTanggal.dart';
import 'package:flutter_pembukuan/model/Kategori.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/catatan/catatanDetailDate.dart';
import 'package:intl/intl.dart';

class CatatanEdit extends StatefulWidget {
  const CatatanEdit({super.key});

  @override
  State<CatatanEdit> createState() => _CatatanEditState();
}

class _CatatanEditState extends State<CatatanEdit> {
  final TextEditingController txtJumlah = TextEditingController();
  TextEditingController txtTanggal = TextEditingController();
  final TextEditingController txtKeterangan = TextEditingController();

  String id_user = '';
  String token = '';
  List<DataKategori> dataKategori = [];
  String kategoriPilihan = '';
  List<DataByTanggal> dataCatatan = [];
  String id_catatan = '';

  String errorMsgInput = '';
  String errorValidasi = '';

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
          kategoriPilihan = '',
          dataKategori = [],
          hasil.data!.forEach(
            (element) {
              dataKategori.add(element);
              if (element.nama_kategori == dataCatatan[0].kategori) {
                kategoriPilihan = element.id.toString();
                id_catatan = dataCatatan[0].id.toString();
                txtTanggal.text = dataCatatan[0].tanggal.toString();
                txtJumlah.text = dataCatatan[0].jumlah.toString();
                txtKeterangan.text = dataCatatan[0].keterangan.toString();
              }
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

  Future getFromDetail(id, tanggal, kategori, tipe, jumlah, keterangan) async {
    dataCatatan = [];
    dataCatatan.add(DataByTanggal(
        id: id,
        tanggal: tanggal,
        kategori: kategori,
        tipe: tipe,
        jumlah: jumlah,
        keterangan: keterangan));
  }

  Future validasiForm() async {
    if (txtTanggal.text == '') {
      errorValidasi = 'Tanggal tidak boleh kosong';
      setState(() {});
    }
    if (txtJumlah.text == '') {
      errorValidasi = 'Jumlah tidak boleh kosong';

      setState(() {});
    }
    if (txtKeterangan.text == '') {
      errorValidasi = 'Keterangan tidak boleh kosong';

      setState(() {});
    }
    errorValidasi = '';
  }

  Future updateCatatan() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Update Catatan..'),
          content: Text('Mohon menunggu! Update Catatan sedang diproses...'),
        ),
      );
      await ApiStatic.putApiUpdateNote(id_catatan, kategoriPilihan,
              txtTanggal.text, txtJumlah.text, txtKeterangan.text, token)
          .then(
        (hasil) => {
          if (hasil.message == 'success')
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return CatatanDetail(date: txtTanggal.text);
              })),
            }
          else
            {
              errorMsgInput = hasil.message.toString(),
              Navigator.of(context).pop(),
              setState(() {}),
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
    DataByTanggal arg =
        ModalRoute.of(context)!.settings.arguments as DataByTanggal;
    getFromDetail(
      arg.id?.toInt(),
      arg.tanggal.toString(),
      arg.kategori.toString(),
      arg.tipe.toString(),
      arg.jumlah?.toInt(),
      arg.keterangan.toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
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
                        // print(kategoriPilihan);
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
                          firstDate: DateTime(2010),
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
                      backgroundColor: Colors.black, // background
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      validasiForm();
                      errorMsgInput = '';
                      (errorValidasi == '')
                          ? updateCatatan()
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cek Inputan Form')),
                            );
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
