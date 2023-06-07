import 'dart:convert';

class Place {
  final String name;
  late String address;
  late int phone;

  Place({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Place.fromJson(Map<String, dynamic> data) {
    return Place(
      name: data['Name'],
      address: data['Address'],
      phone: data['Phone'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'Name': name,
      'Address': address,
      'Phone_1': phone,
    };
    return jsonEncode(data);
  }
}
