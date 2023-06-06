import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/login_provider.dart';
import 'package:flutter/material.dart';

import '../services/session_service.dart';

dynamic checkSession(context) async {
  final data = await checkSessionHttp();
  if (data != false) {
    redirectLogin(Employee.fromJson(data), context);
  }
}

closeSession(context) async {
  final closed = await closeSessionHttp();
  if (closed) {
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
