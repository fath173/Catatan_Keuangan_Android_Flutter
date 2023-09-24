// ignore_for_file: file_names

class Registrasi {
  String? message;
  String? errors;

  Registrasi({
    this.message,
    this.errors,
  });

  Registrasi.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errors = json['errors']['email'][0].toString();
  }
}
