import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/models/mental_health.dart';

class MentalHealthBloc {
  static Future<List<MentalHealth>> getMentalHealthEntries() async {
    String apiUrl = ApiUrl.listMentalHealth;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listData = (jsonObj as Map<String, dynamic>)['data'];
    List<MentalHealth> entries = [];
    for (int i = 0; i < listData.length; i++) {
      entries.add(MentalHealth.fromJson(listData[i]));
    }
    return entries;
  }

  static Future addMentalHealthEntry({MentalHealth? entry}) async {
    String apiUrl = ApiUrl.createMentalHealth;

    var body = {
      "mental_state": entry!.mentalState,
      "therapy_sessions": entry.therapySessions.toString(),
      "medication": entry.medication
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateMentalHealthEntry({required MentalHealth entry}) async {
    String apiUrl = ApiUrl.updateMentalHealth(entry.id!);

    var body = {
      "mental_state": entry.mentalState,
      "therapy_sessions": entry.therapySessions,
      "medication": entry.medication
    };

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteMentalHealthEntry({int? id}) async {
    String apiUrl = ApiUrl.deleteMentalHealth(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
