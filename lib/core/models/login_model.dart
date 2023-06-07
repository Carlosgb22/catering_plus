import 'dart:convert';

class Login {
  final String dni;
  final String password;

  Login({
    required this.dni,
    required this.password,
  });

  ///Metodo el cual obtiene datos en forma de mapa y devuelve un login
  factory Login.fromJson(Map<String, dynamic> data) {
    return Login(
      dni: data['DNI'],
      password: data['Password'],
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'DNI': dni,
      'Password': password,
    };
    return jsonEncode(data);
  }
}
