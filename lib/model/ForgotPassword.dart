class ForgotPassword {
  String? message;

  ForgotPassword({this.message});

  ForgotPassword.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
