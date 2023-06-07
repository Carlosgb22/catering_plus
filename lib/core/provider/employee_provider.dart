import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/login_provider.dart';

import '../services/employee_service.dart';

Future<Employee> getEmployee(String dni) {
  return getEmployeeByIdHttp(dni);
}

Future<List<Employee>> getAllEmployees(int idCatering) {
  return getAllEmployeesHttp(idCatering);
}

deleteEmployee(String dni) {
  deleteEmployeeHttp(dni);
}

updateEmployee(Employee employee) {
  updateEmployeeHttp(employee);
}

addEmployee(Employee employee) {
  addEmployeeHttp(employee);
  addLogin(employee.dni);
}
