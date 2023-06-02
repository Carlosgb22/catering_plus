import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/login_provider.dart';
import 'package:catering_plus/core/services/api_service.dart';

import '../services/session_service.dart';

final ApiService apiService = ApiService();

dynamic checkSession(context) async {
  final data = await checkSessionHttp();
  if (data != false) {
    redirectLogin(Employee.fromJson(data), context);
  }
}
