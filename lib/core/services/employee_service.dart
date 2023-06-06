import 'package:catering_plus/core/config/config.dart';
import 'package:dio/dio.dart';

import '../models/employee_model.dart';

final dio = Dio();

Future<Employee> getEmployeeByIdHttp(dni) async {
  var response = await dio.get("http://$ip:$port/employee/$dni");
  if (response.statusCode == 200) {
    return Employee.fromJson(response.data);
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<List<Employee>> getAllEmployeesHttp(idCatering) async {
  var response = await dio.get("http://$ip:$port/employee/all/$idCatering");
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
  await dio.post("http://$ip:$port/employee/add",
      data: emp.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

updateEmployeeHttp(Employee emp) async {
  await dio.post("http://$ip:$port/employee/${emp.dni}/update",
      data: emp.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

deleteEmployeeHttp(dni) async {
  await dio.delete("http://$ip:$port/employee/$dni");
}
