// ignore_for_file: file_names
// harus pake ? biar nggak error
class GetByTanggal {
  String? message;
  String? tanggal;
  int? pemasukan;
  int? pengeluaran;
  List<DataByTanggal>? data;

  GetByTanggal({
    this.message,
    this.tanggal,
    this.pemasukan,
    this.pengeluaran,
    this.data,
  });

  GetByTanggal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tanggal = json['tanggal'];
    pemasukan = json['pemasukan'];
    pengeluaran = json['pengeluaran'];

    if (json['data'] != null) {
      data = <DataByTanggal>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataByTanggal.fromJson(e));
      }
    }
  }

  get isEmpty => null;
}

class DataByTanggal {
  int? id;
  String? tanggal;
  String? kategori;
  String? tipe;
  int? jumlah;
  String? keterangan;

  DataByTanggal(
      {this.id,
      this.tanggal,
      this.kategori,
      this.tipe,
      this.jumlah,
      this.keterangan});

  DataByTanggal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    kategori = json['kategori'];
    tipe = json['tipe'];
    jumlah = json['jumlah'];
    keterangan = json['keterangan'];
  }
}
