import 'package:catering_plus/core/services/api_service.dart';

final ApiService apiService = ApiService();

Future<bool> getLoginByIdHttp(dni, pass) async {
  var response =
      await apiService.dio.get("http://localhost:8080/login/$dni/$pass");
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}
