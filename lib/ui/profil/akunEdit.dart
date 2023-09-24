import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/model/AkunSaya.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/landing.dart';
import 'package:intl/intl.dart';

class AkunEdit extends StatefulWidget {
  const AkunEdit({super.key});

  @override
  State<AkunEdit> createState() => _AkunEditState();
}

class _AkunEditState extends State<AkunEdit> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtTglLahir = TextEditingController();
  final TextEditingController txtTelepon = TextEditingController();
  final TextEditingController txtAlamat = TextEditingController();

  String id_user = '';
  String token = '';
  List<DataAkun> dataUser = [];

  String message = '';
  String errorValidasi = '';
  String _errorValidasiEmail = '';
  String errorMsgInput = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v_id) => id_user = v_id.toString());
    SharedLogin.getToken().then((v_token) => token = v_token);
    getDataAkun();
  }

  Future validasiForm() async {
    if (txtName.text == '') {
      setState(() {
        errorValidasi = 'Nama tidak boleh kosong';
      });
    }
    if (txtEmail.text == '') {
      setState(() {
        errorValidasi = 'Email tidak boleh kosong';
      });
      return 0;
    }
    if (txtTelepon.text == '') {
      errorValidasi = 'Telepon tidak boleh kosong';
      return 0;
    }
    if (txtAlamat.text == '') {
      errorValidasi = 'Alamat tidak boleh kosong';
      return 0;
    }
    errorValidasi = '';
  }

  Future getDataAkun() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiStatic.getApiMyAkun(id_user, token).then(
        (hasil) => {
          dataUser = [],
          hasil.data!.forEach(
            (element) {
              dataUser.add(element);
            },
          ),
          txtEmail.text = dataUser[0].email.toString(),
          txtName.text = dataUser[0].name.toString(),
          txtTglLahir.text = (dataUser[0].tanggal_lahir == null)
              ? ''
              : dataUser[0].tanggal_lahir.toString(),
          txtTelepon.text = (dataUser[0].telepon == null)
              ? ''
              : dataUser[0].telepon.toString(),
          txtAlamat.text =
              (dataUser[0].alamat == null) ? '' : dataUser[0].alamat.toString(),
        },
      );
    } catch (e) {
      print('terjadi kesalahan profile');
      print(e.toString());
    }
  }

  Future updateAkun() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Proses Update Akun..'),
          content: Text('Mohon menunggu! Update Akun sedang diproses...'),
        ),
      );
      await ApiStatic.putApiUpdateBio(id_user, txtName.text, txtEmail.text,
              txtTglLahir.text, txtTelepon.text, txtAlamat.text, token)
          .then(
        (hasil) => {
          if (hasil.message! == 'success')
            {
              getDataAkun(),
              Navigator.of(context).pop(),
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(milliseconds: 1200), () {
                      Navigator.of(context).pop(true);
                    });
                    return const AlertDialog(
                      title: Text('Berhasil Update!',
                          style: TextStyle(color: Colors.green)),
                    );
                  }),
            }
          else
            {
              errorMsgInput = hasil.message.toString(),
              Navigator.of(context).pop(),
              setState(() {}),
            }
        },
      );
    } catch (e) {
      print('terjadi kesalahan');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Biodata'),
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
                  child: TextField(
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Tulis Email disini..',
                    ),
                    onChanged: (value) {
                      validateEmail(value);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    controller: txtName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama',
                      hintText: 'Tulis Nama Anda..',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    controller: txtTglLahir,
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

                      txtTglLahir.text = date;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                      controller: txtTelepon,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Telepon',
                        hintText: 'Tulis No Telepon Anda..',
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
                    controller: txtAlamat,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat',
                      hintText: 'Tulis Alamat Anda..',
                    ),
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
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: const Color(0xFF9C27B0), // background
                    ),
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      validasiForm();
                      errorMsgInput = '';
                      (errorValidasi == '')
                          ? updateAkun()
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cek Inputan Form')),
                            );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/akunPassword');
                    },
                    child: const Text('Ubah Password')),
              ])),
        ),
      ),
    );
  }

  void validateEmail(String val) {
    errorValidasi = '';
    if (val.isEmpty) {
      setState(() {
        _errorValidasiEmail = "Email tidak boleh kosong";
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _errorValidasiEmail = "Penulisan Email Salah";
      });
    } else {
      setState(() {
        _errorValidasiEmail = '';
      });
    }
    print(_errorValidasiEmail);
  }
}
