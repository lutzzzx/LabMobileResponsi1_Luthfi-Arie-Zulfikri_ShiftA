class Registrasi {
  int? code;
  bool? status;
  String? message;

  Registrasi({this.code, this.status, this.message});

  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    return Registrasi(
      code: obj['code'],
      status: obj['status'],
      message: obj['data'],
    );
  }
}
