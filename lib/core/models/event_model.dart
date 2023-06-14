import 'dart:convert';

class Event {
  late int? id;
  final int idCatering;
  late DateTime date;
  late int phone1;
  late int? phone2;
  late String place;
  late int assemblyHours;
  late int serviceHours;
  late int openBarHours;
  late int revised;

  Event({
    this.id,
    required this.idCatering,
    required this.date,
    required this.phone1,
    this.phone2,
    required this.place,
    required this.assemblyHours,
    required this.serviceHours,
    required this.openBarHours,
    required this.revised,
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    return Event(
      id: data['ID'],
      idCatering: data['Id_Catering'],
      date: DateTime.parse(data['Date']),
      phone1: data['Phone_1'],
      phone2: data['Phone_2'],
      place: data['Place_Name'],
      assemblyHours: data['Assembly_Hours'],
      serviceHours: data['Service_Hours'],
      openBarHours: data['OpenBar_Hours'],
      revised: data['revised'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'ID': id,
      'Id_Catering': idCatering,
      'Date': date.toString(),
      'Phone_1': phone1,
      'Place_Name': place,
      'Assembly_Hours': assemblyHours,
      'Service_Hours': serviceHours,
      'OpenBar_Hours': openBarHours,
      'revised': revised,
    };
    if (phone2 != null) {
      data['Phone_2'] = phone2;
    }
    return jsonEncode(data);
  }
}
