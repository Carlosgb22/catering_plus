import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';

final dio = Dio();

Future<dynamic> checkSessionHttp() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? dni = sharedPreferences.getString('dni');
  var response = await dio.get("http://$ip:$port/checkSession/$dni");
  if (response.statusCode == 200) {
    return response.data;
  } else {
    return false;
  }
}

Future<bool> closeSessionHttp() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove('dni');
  var response = await dio.get("http://$ip:$port/closeSession");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
