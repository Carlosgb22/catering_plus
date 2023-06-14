import 'dart:convert';

class Work {
  final String dni;
  final int eventId;
  final int idCatering;
  final int master;
  final int assembly;
  final int service;
  final int openBar;

  Work({
    required this.dni,
    required this.eventId,
    required this.idCatering,
    required this.master,
    required this.assembly,
    required this.service,
    required this.openBar,
  });

  factory Work.fromJson(Map<String, dynamic> data) {
    return Work(
      dni: data['DNI'],
      eventId: data['Event_ID'],
      idCatering: data['Id_Catering'],
      master: data['Master'],
      assembly: data['Assembly'],
      service: data['Service'],
      openBar: data['OpenBar'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'DNI': dni,
      'Event_Id': eventId,
      'Id_Catering': idCatering,
      'Master': master,
      'Assembly': assembly,
      'Service': service,
      'OpenBar': openBar,
    };
    return jsonEncode(data);
  }
}
