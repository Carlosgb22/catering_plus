import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';

class EmployeeView extends StatefulWidget {
  final Employee emp;

  const EmployeeView({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeView> {
  late Employee emp;

  @override
  void initState() {
    super.initState();
    emp = widget.emp;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
