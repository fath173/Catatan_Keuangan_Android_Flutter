class Pengguna {
  String? message;
  List<DataPengguna>? data;

  Pengguna({this.message, this.data});

  Pengguna.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] != null) {
      data = <DataPengguna>[];
      for (var e in (json['data'] as List)) {
        data!.add(DataPengguna.fromJson(e));
      }
    }
  }
}

class DataPengguna {
  int? id;
  String? name;
  String? email;
  String? alamat;

  DataPengguna({this.id, this.name, this.email, this.alamat});

  DataPengguna.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    alamat = json['alamat'];
  }
}
