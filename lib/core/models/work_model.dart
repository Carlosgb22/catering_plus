import 'dart:convert';

class Work {
  final String dni;
  final int eventId;
  final int idCatering;
  final int master;

  Work(
      {required this.dni,
      required this.eventId,
      required this.idCatering,
      required this.master});

  factory Work.fromJson(Map<String, dynamic> data) {
    return Work(
        dni: data['DNI'],
        eventId: data['Event_ID'],
        idCatering: data['Id_Catering'],
        master: data['Master']);
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'DNI': dni,
      'Event_Id': eventId,
      'Id_Catering': idCatering,
      'Master': master,
    };
    return jsonEncode(data);
  }
}
