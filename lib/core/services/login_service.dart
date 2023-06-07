import 'package:catering_plus/core/models/login_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';

final dio = Dio();
Future<bool> getLoginByIdHttp(dni, pass) async {
  var response = await dio.get("http://$ip:$port/login/$dni/$pass");
  if (response.statusCode == 200) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('dni', dni);
    return response.data;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

addLoginHttp(String dni) async {
  Login login = Login(dni: dni, password: 'pass');
  var response = await dio.post("http://$ip:$port/login/add",
      data: login.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

deleteLoginHttp(dni) async {
  await dio.delete("http://$ip:$port/login/$dni");
}
