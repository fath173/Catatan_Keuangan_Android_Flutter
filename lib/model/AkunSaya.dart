// ignore_for_file: file_names, non_constant_identifier_names

class MyAkun {
  String? message;
  List<DataAkun>? data;

  MyAkun({
    this.message,
    this.data,
  });

  MyAkun.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] != null) {
      data = <DataAkun>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataAkun.fromJson(e));
      }
    }
  }
}

class DataAkun {
  int? id;
  String? name;
  String? email;
  String? role;
  String? tanggal_lahir;
  String? telepon;
  String? foto;
  String? alamat;

  DataAkun({
    this.id,
    this.name,
    this.email,
    this.role,
    this.tanggal_lahir,
    this.telepon,
    this.foto,
    this.alamat,
  });

  DataAkun.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    tanggal_lahir = json['tanggal_lahir'];
    telepon = json['telepon'];
    foto = json['foto'];
    alamat = json['alamat'];
  }
}

class AkunUpdate {
  String? message;
  String? data;

  AkunUpdate({this.message, this.data});

  AkunUpdate.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}

class UpdatePassword {
  String? message;

  UpdatePassword({this.message});

  UpdatePassword.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
