class CatatanAdd {
  String? message;
  String? data;

  CatatanAdd({this.message, this.data});

  CatatanAdd.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}

class CatatanUpdate {
  String? message;
  String? data;

  CatatanUpdate({this.message, this.data});

  CatatanUpdate.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}

class DeleteCatatan {
  String? message;
  String? data;

  DeleteCatatan({this.message, this.data});

  DeleteCatatan.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}
