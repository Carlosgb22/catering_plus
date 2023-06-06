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
