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

  // ///Metodo para obtener un json a partir de un dispositivo
  // String toJson() {
  //   return '{"id": "$id", "name": "$name", "userUid": "$userUid", "imgcon": "$imgcon", "imgdiscon": "$imgdiscon", "imgwait": "$imgwait"}';
  // }

  // @override
  // String toString() {
  //   return 'Device{id: $id, name: $name, userUid: $userUid, imgcon: $imgcon, imgdiscon: $imgdiscon, imgwait: $imgwait}';
  // }
}
