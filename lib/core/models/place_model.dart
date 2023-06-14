import 'dart:convert';

class Place {
  final String name;
  int idCatering;
  late String address;
  late int phone;

  Place({
    required this.name,
    required this.idCatering,
    required this.address,
    required this.phone,
  });

  factory Place.fromJson(Map<String, dynamic> data) {
    return Place(
      name: data['Name'],
      idCatering: data['Id_Catering'],
      address: data['Address'],
      phone: data['Phone'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'Name': name,
      'Id_Catering': idCatering,
      'Address': address,
      'Phone': phone,
    };
    return jsonEncode(data);
  }
}
