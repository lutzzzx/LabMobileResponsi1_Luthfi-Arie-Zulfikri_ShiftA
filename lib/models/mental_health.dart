class MentalHealth {
  int? id;
  String? mentalState;
  int? therapySessions;
  String? medication;
  DateTime? createdAt;
  DateTime? updatedAt;

  MentalHealth({
    this.id,
    this.mentalState,
    this.therapySessions,
    this.medication,
    this.createdAt,
    this.updatedAt,
  });

  factory MentalHealth.fromJson(Map<String, dynamic> obj) {
    return MentalHealth(
      id: obj['id'],
      mentalState: obj['mental_state'],
      therapySessions: obj['therapy_sessions'],
      medication: obj['medication'],
      createdAt: DateTime.parse(obj['created_at']),
      updatedAt: DateTime.parse(obj['updated_at']),
    );
  }
}
