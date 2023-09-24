// ignore_for_file: file_names, non_constant_identifier_names
class LoginModel {
  int id;
  String role;
  String token;
  String email_verified_at;
  String message;

  LoginModel(
      {required this.id,
      required this.role,
      required this.email_verified_at,
      required this.token,
      required this.message});

  factory LoginModel.ambilUser(Map<String, dynamic> json) {
    return LoginModel(
        id: json['id'],
        role: json['role'],
        email_verified_at: json['email_verified_at'],
        token: json['token'],
        message: json['message']);
  }
}

class LogoutModel {
  String message;
  LogoutModel({
    required this.message,
  });

  factory LogoutModel.logoutUser(Map<String, dynamic> json) {
    print(json['message']);
    return LogoutModel(message: json['message']);
  }
}
