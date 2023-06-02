import 'dart:convert';

class Employee {
  late final String dni;
  final int idCatering;
  late String name;
  late String familyName;
  late int phone;
  late int ss;
  late int clerk;
  final int admin;

  Employee({
    required this.dni,
    required this.idCatering,
    required this.name,
    required this.familyName,
    required this.phone,
    required this.ss,
    required this.clerk,
    required this.admin,
  });

  factory Employee.fromJson(Map<String, dynamic> data) {
    return Employee(
      dni: data['DNI'],
      idCatering: data['Id_Catering'],
      name: data['Name'],
      familyName: data['Family_Name'],
      phone: data['Phone'],
      ss: data['SS'],
      clerk: data['Clerk'],
      admin: data['Admin'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'DNI': dni,
      'Id_Catering': idCatering,
      'Name': name,
      'Family_Name': familyName,
      'Phone': phone,
      'SS': ss,
      'Clerk': clerk,
      'Admin': admin,
    };
    return jsonEncode(data);
  }
}
