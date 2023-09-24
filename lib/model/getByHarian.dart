// ignore_for_file: file_names
// harus pake ? biar nggak error
class Harian {
  String? message;
  List<DataHarian>? data;

  Harian({
    this.message,
    this.data,
  });

  Harian.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] != null) {
      data = <DataHarian>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataHarian.fromJson(e));
      }
    }
  }
}

class DataHarian {
  String? tanggal;
  int? pemasukan;
  int? pengeluaran;

  DataHarian({
    this.tanggal,
    this.pemasukan,
    this.pengeluaran,
  });

  DataHarian.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    pemasukan = json['pemasukan'];
    pengeluaran = json['pengeluaran'];
  }
}
