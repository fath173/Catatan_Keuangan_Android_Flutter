class CsrfToken {
  String? csrf;

  CsrfToken({this.csrf});

  CsrfToken.fromJson(Map<String, dynamic> json) {
    csrf = json['csrf'];
  }
}
