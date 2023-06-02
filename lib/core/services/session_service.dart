import 'package:catering_plus/core/services/api_service.dart';

final ApiService apiService = ApiService();

Future<dynamic> checkSessionHttp() async {
  var response = await apiService.dio.get("http://localhost:8080/checkSession");
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}
