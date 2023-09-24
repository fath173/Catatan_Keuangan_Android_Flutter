// ignore_for_file: non_constant_identifier_names

class Kategori {
  String? message;
  List<DataKategori>? data;

  Kategori({this.message, this.data});

  Kategori.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] != null) {
      data = <DataKategori>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataKategori.fromJson(e));
      }
    }
  }
}

class DataKategori {
  int? id;
  String? nama_kategori;
  String? tipe;

  DataKategori({this.id, this.nama_kategori, this.tipe});
  DataKategori.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama_kategori = json['nama_kategori'];
    tipe = json['tipe'];
  }
}

class KategoriAdd {
  String? message;
  String? data;

  KategoriAdd({this.message, this.data});

  KategoriAdd.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}

class KategoriUpdate {
  String? message;
  String? data;

  KategoriUpdate({this.message, this.data});

  KategoriUpdate.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}

class DeleteKategori {
  String? message;
  String? data;

  DeleteKategori({this.message, this.data});

  DeleteKategori.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}
