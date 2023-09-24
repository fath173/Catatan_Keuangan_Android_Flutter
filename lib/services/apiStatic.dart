// ignore_for_file: non_constant_identifier_names

import 'package:flutter_pembukuan/model/Catatan.dart';
import 'package:flutter_pembukuan/model/ForgotPassword.dart';
import 'package:flutter_pembukuan/model/getAllCatatan.dart';
import 'package:flutter_pembukuan/model/getByBulanan.dart';
import 'package:flutter_pembukuan/model/getByHarian.dart';
import 'package:flutter_pembukuan/model/getByTanggal.dart';
import 'package:flutter_pembukuan/model/getCsrfToken.dart';
import 'package:flutter_pembukuan/model/AkunSaya.dart';
import 'package:flutter_pembukuan/model/Kategori.dart';
import 'package:flutter_pembukuan/model/pengguna.dart';
import 'package:flutter_pembukuan/model/LoginModel.dart';
import 'package:flutter_pembukuan/model/Registrasi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiStatic {
  static String urlServer = '192.168.1.19/projek_flutter/public';

  // get login user
  static Future<LoginModel> getApiLogin(String email, String password) async {
    String apiUrl = 'http://$urlServer/api/login';

    var apiResult = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return LoginModel.ambilUser(jsonObject);
  }

  // get logout user
  static Future<LogoutModel> getApiLogout(String id, String token) async {
    String apiUrl = 'http://$urlServer/api/logout';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id': id,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return LogoutModel.logoutUser(jsonObject);
  }

  // get XSRF-TOKEN dari laravel
  static Future<CsrfToken> getWebCsrfToken() async {
    String apiUrl = 'http://$urlServer/token';

    var apiResult = await http.get(Uri.parse(apiUrl));

    var jsonObject = jsonDecode(apiResult.body);
    return CsrfToken.fromJson(jsonObject);
  }

  // post Register user
  static Future<Registrasi> getApiRegister(String name, String email,
      String password, String passwordConfirm, String csrf) async {
    String apiUrl = 'http://$urlServer/api/register';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'X-XSRF-TOKEN': csrf,
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return Registrasi.fromJson(jsonObject);
  }

  // post Forgot Password user
  static Future<ForgotPassword> getApiForgotPassword(
      String email, String csrf) async {
    String apiUrl = 'http://$urlServer/api/password/email';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'X-XSRF-TOKEN': csrf,
    }, body: {
      'email': email,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return ForgotPassword.fromJson(jsonObject);
  }

  // get by tanggal
  static Future<GetByTanggal> getApiByTanggal(
      String id, String tanggal, String token) async {
    String apiUrl = 'http://$urlServer/api/dataByTanggal';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id': id,
      'tanggal': tanggal,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return GetByTanggal.fromJson(jsonObject);
  }

  // get data harian user
  static Future<Harian> getApiHarian(String id, String token) async {
    String apiUrl = 'http://$urlServer/api/dataHarian';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id': id,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return Harian.fromJson(jsonObject);
  }

  // get data harian user
  static Future<Bulanan> getApiByBulanan(
      String id, String bulan, String tahun, String token) async {
    String apiUrl = 'http://$urlServer/api/dataByMonth';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id': id,
      'bulan': bulan,
      'tahun': tahun,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return Bulanan.fromJson(jsonObject);
  }

  // get data harian user
  static Future<MyAkun> getApiMyAkun(String id, String token) async {
    String apiUrl = 'http://$urlServer/api/akun/$id';

    var apiResult = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    var jsonObject = jsonDecode(apiResult.body);

    return MyAkun.fromJson(jsonObject);
  }

  // get data Kategori Catatan
  static Future<Kategori> getApiKategori(String token) async {
    String apiUrl = 'http://$urlServer/api/kategori';

    var apiResult = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    var jsonObject = jsonDecode(apiResult.body);

    return Kategori.fromJson(jsonObject);
  }

  // post Tambah Catatan
  static Future<CatatanAdd> postApiAddNote(
    String id_user,
    String id_kategori,
    String tanggal,
    String jumlah,
    String keterangan,
    String token,
  ) async {
    String apiUrl = 'http://$urlServer/api/catatan/input';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id_user': id_user,
      'id_kategori': id_kategori,
      'tanggal': tanggal,
      'jumlah': jumlah,
      'keterangan': keterangan,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return CatatanAdd.fromJson(jsonObject);
  }

  // put Update Catatan
  static Future<CatatanUpdate> putApiUpdateNote(
      String id_note,
      String id_kategori,
      String tanggal,
      String jumlah,
      String keterangan,
      String token) async {
    String apiUrl = 'http://$urlServer/api/catatan/$id_note/update';

    var apiResult = await http.put(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'id_kategori': id_kategori,
      'tanggal': tanggal,
      'jumlah': jumlah,
      'keterangan': keterangan,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return CatatanUpdate.fromJson(jsonObject);
  }

  // put Delete Catatan
  static Future<DeleteCatatan> delApiDeleteNote(
      String id_note, String token) async {
    String apiUrl = 'http://$urlServer/api/catatan/$id_note/delete';

    var apiResult = await http.delete(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    var jsonObject = jsonDecode(apiResult.body);

    return DeleteCatatan.fromJson(jsonObject);
  }

  // get by Catatan All User
  static Future<Pengguna> getAllUser(token) async {
    String apiUrl = 'http://$urlServer/api/user/all';

    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });
    var jsonObject = jsonDecode(response.body);
    var hasilApi = Pengguna.fromJson(jsonObject);

    return hasilApi;
  }

  // get by Catatan iduser
  static Future<AllCatatan> getApiCatatanByIdUser(
      String id, String token) async {
    String apiUrl = 'http://$urlServer/api/catatan/$id';

    var apiResult = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    var jsonObject = jsonDecode(apiResult.body);

    return AllCatatan.fromJson(jsonObject);
  }

// put Update Akun Biodata
  static Future<AkunUpdate> putApiUpdateBio(
      String id_user,
      String name,
      String email,
      String tanggal_lahir,
      String telepon,
      String alamat,
      String token) async {
    String apiUrl = 'http://$urlServer/api/akun/$id_user/bio';

    var apiResult = await http.put(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': name,
      'email': email,
      'tanggal_lahir': tanggal_lahir,
      'telepon': telepon,
      'alamat': alamat,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return AkunUpdate.fromJson(jsonObject);
  }

// put Update Akun Biodata
  static Future<AkunUpdate> putApiUpdatePassword(
      String id_user,
      String password_old,
      String password,
      String password_confirm,
      String token) async {
    String apiUrl = 'http://$urlServer/api/akun/$id_user/password';

    var apiResult = await http.put(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'password_old': password_old,
      'password': password,
      'password_confirmation': password_confirm,
    });

    var jsonObject = jsonDecode(apiResult.body);

    return AkunUpdate.fromJson(jsonObject);
  }

  // post Tambah Kategori
  static Future<KategoriAdd> postApiAddKategori(
    String nama_kategori,
    String tipe,
    String token,
  ) async {
    String apiUrl = 'http://$urlServer/api/kategori/input';

    var apiResult = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'nama_kategori': nama_kategori,
      'tipe': tipe,
    });

    var jsonObject = jsonDecode(apiResult.body);
    var output = KategoriAdd.fromJson(jsonObject);
    print("output adalah: $output");

    return output;
  }

  // put Update Kategori
  static Future<KategoriUpdate> putApiUpdateKategori(
    String idKategori,
    String nama_kategori,
    String tipe,
    String token,
  ) async {
    String apiUrl = 'http://$urlServer/api/kategori/$idKategori/update';

    var apiResult = await http.put(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'nama_kategori': nama_kategori,
      'tipe': tipe,
    });
    var jsonObject = jsonDecode(apiResult.body);

    return KategoriUpdate.fromJson(jsonObject);
  }

  // put Delete Kategori
  static Future<DeleteKategori> delApiDeleteKategori(
      String idKategori, String token) async {
    String apiUrl = 'http://$urlServer/api/kategori/$idKategori/delete';

    var apiResult = await http.delete(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    var jsonObject = jsonDecode(apiResult.body);

    return DeleteKategori.fromJson(jsonObject);
  }
}
