import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/admin/kategori/kategoriAll.dart';

class KategoriTambah extends StatefulWidget {
  const KategoriTambah({super.key});

  @override
  State<KategoriTambah> createState() => _KategoriTambahState();
}

class _KategoriTambahState extends State<KategoriTambah> {
  final TextEditingController txtNamaKategori = TextEditingController();
  String tipePilihan = '';

  String id_user = '';
  String token = '';
  String errorMsgInput = '';
  String errorValidasi = '';
  String message = '';
  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
  }

  List<DropdownMenuItem> buatTipeKategori() {
    List<DropdownMenuItem> items = [
      const DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
      const DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
    ];
    tipePilihan = 'pemasukan';
    return items;
  }

  Future validasiForm() async {
    if (txtNamaKategori.text == '') {
      errorValidasi = 'Keterangan tidak boleh kosong';
      return 0;
    }
    errorValidasi = '';
    return 1;
  }

  Future tambahKategori() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Tambah Kategori..'),
          content: Text('Mohon menunggu! Tambah Kategori sedang diproses...'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.postApiAddKategori(
              txtNamaKategori.text, tipePilihan, token)
          .then(
        (hasil) => {
          if (hasil.message! == 'success')
            {
              message = hasil.data!.toString(),
              Navigator.of(context).pop(),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const KategoriPage();
              })),
            }
          else
            {
              errorMsgInput = hasil.message!.toString(),
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
        title: const Text('Tambah Kategori'),
        // centerTitle: mounted,
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
                    items: buatTipeKategori(),
                    isExpanded: true,
                    hint: const Text('Pilih Tipe'),
                    value: tipePilihan,
                    onChanged: (item) {
                      tipePilihan = item;
                      print(tipePilihan);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    controller: txtNamaKategori,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Kategori',
                      hintText: 'Tulis Nama Kategori Kategori..',
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
                          ? tambahKategori()
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
                    Text((errorValidasi == '') ? '' : errorValidasi,
                        style: const TextStyle(color: Colors.red)),
                    Text((message == '') ? '' : message,
                        style: const TextStyle(color: Colors.blue)),
                  ]),
                ),
              ])),
        ),
      ),
    );
  }
}
