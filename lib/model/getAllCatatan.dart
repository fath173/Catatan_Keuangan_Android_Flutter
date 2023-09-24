// ignore_for_file: file_names
// harus pake ? biar nggak error
class AllCatatan {
  String? message;
  int? id_user;
  String? name;
  List<DataAllCatatan>? data;

  AllCatatan({
    this.message,
    this.id_user,
    this.name,
    this.data,
  });

  AllCatatan.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id_user = json['id'];
    name = json['name'];

    if (json['data'] != null) {
      data = <DataAllCatatan>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataAllCatatan.fromJson(e));
      }
    }
  }
}

class DataAllCatatan {
  int? id;
  String? tanggal;
  int? jumlah;
  String? keterangan;
  String? nama_kategori;
  String? tipe;

  DataAllCatatan({
    this.id,
    this.tanggal,
    this.jumlah,
    this.keterangan,
    this.nama_kategori,
    this.tipe,
  });

  DataAllCatatan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    jumlah = json['jumlah'];
    keterangan = json['keterangan'];
    nama_kategori = json['nama_kategori'];
    tipe = json['tipe'];
  }
}
