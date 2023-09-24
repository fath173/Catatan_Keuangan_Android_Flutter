// ignore_for_file: non_constant_identifier_names, file_names
// harus pake ? biar nggak error
class Bulanan {
  String? message;
  int? pemasukan;
  int? pengeluaran;
  int? total_bersih;
  List<TopPemasukan>? topPemasukan;
  List<TopPengeluaran>? topPengeluaran;

  Bulanan({
    this.message,
    this.pemasukan,
    this.pengeluaran,
    this.total_bersih,
    this.topPemasukan,
    this.topPengeluaran,
  });

  Bulanan.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    pemasukan = json['pemasukan'];
    pengeluaran = json['pengeluaran'];
    total_bersih = json['total_bersih'];

    if (json['topPemasukan'] != null) {
      topPemasukan = <TopPemasukan>[];
      for (var e in (json['topPemasukan'] as List)) {
        topPemasukan!.add(TopPemasukan.fromJson(e));
      }
    }

    if (json['topPengeluaran'] != null) {
      topPengeluaran = <TopPengeluaran>[];
      for (var e in (json['topPengeluaran'] as List)) {
        topPengeluaran!.add(TopPengeluaran.fromJson(e));
      }
    }
  }
}

class TopPemasukan {
  String? tanggal;
  String? kategori;
  int? jumlah;
  String? keterangan;

  TopPemasukan({
    this.tanggal,
    this.kategori,
    this.jumlah,
    this.keterangan,
  });

  TopPemasukan.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    kategori = json['kategori'];
    jumlah = json['jumlah'];
    keterangan = json['keterangan'];
  }
}

class TopPengeluaran {
  String? tanggal;
  String? kategori;
  int? jumlah;
  String? keterangan;

  TopPengeluaran({
    this.tanggal,
    this.kategori,
    this.jumlah,
    this.keterangan,
  });

  TopPengeluaran.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    kategori = json['kategori'];
    jumlah = json['jumlah'];
    keterangan = json['keterangan'];
  }
}
