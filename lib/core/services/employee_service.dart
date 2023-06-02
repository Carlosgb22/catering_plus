import 'package:catering_plus/core/services/api_service.dart';
import 'package:dio/dio.dart';

import '../models/employee_model.dart';

final ApiService apiService = ApiService();

Future<Employee> getEmployeeByIdHttp(dni) async {
  var response =
      await apiService.dio.get("http://localhost:8080/employee/$dni");
  if (response.statusCode == 200) {
    return Employee.fromJson(response.data);
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<List<Employee>> getAllEmployeesHttp(idCatering) async {
  var response = await apiService.dio
      .get("http://localhost:8080/employee/all/$idCatering");
  if (response.statusCode == 200) {
    response.data;
    final employeeList =
        (response.data as List).map((e) => Employee.fromJson(e)).toList();
    return employeeList;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

addEmployeeHttp(Employee emp) async {
  await apiService.dio.post("http://localhost:8080/employee/add",
      data: emp.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

updateEmployeeHttp(Employee emp) async {
  await apiService.dio.post("http://localhost:8080/employee/${emp.dni}/update",
      data: emp.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

deleteEmployeeHttp(dni) async {
  await apiService.dio.delete("http://localhost:8080/employee/$dni");
}
