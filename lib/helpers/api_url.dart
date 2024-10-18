class ApiUrl {
  static const String baseUrl = 'https://responsi.webwizards.my.id/api';

  // Endpoint registrasi
  static const String registrasi = baseUrl + '/registrasi';

  // Endpoint login
  static const String login = baseUrl + '/login';

  // Endpoint daftar kesehatan mental (Get All)
  static const String listMentalHealth = baseUrl + '/kesehatan/kesehatan_mental';

  // Endpoint membuat entri kesehatan mental
  static const String createMentalHealth = baseUrl + '/kesehatan/kesehatan_mental';

  // Endpoint memperbarui entri kesehatan mental
  static String updateMentalHealth(int id) {
    return baseUrl + '/kesehatan/kesehatan_mental/' + id.toString() + '/update';
  }

  // Endpoint melihat detail entri kesehatan mental
  static String showMentalHealth(int id) {
    return baseUrl + '/kesehatan/kesehatan_mental/' + id.toString();
  }

  // Endpoint menghapus entri kesehatan mental
  static String deleteMentalHealth(int id) {
    return baseUrl + '/kesehatan/kesehatan_mental/' + id.toString() + '/delete';
  }
}