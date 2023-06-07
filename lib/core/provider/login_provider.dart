import 'package:flutter/material.dart';

import '../../ui/view/admin/admin_ini.dart';
import '../../ui/view/clerk/clerk_ini.dart';
import '../../ui/view/employee/employee_ini.dart';
import '../models/employee_model.dart';
import '../services/login_service.dart';

Future<bool> login(String dni, String password) async {
  return await getLoginByIdHttp(dni, password);
}

addLogin(String dni) async {
  return await addLoginHttp(dni);
}

deleteLogin(String dni) async {
  return await deleteLoginHttp(dni);
}

redirectLogin(Employee emp, context) async {
  if (emp.admin == 1) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Admin(emp: emp)),
        (route) => false);
  } else if (emp.clerk == 1) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Clerk(emp: emp)),
        (route) => false);
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmployeeView(emp: emp)),
        (route) => false);
  }
}
