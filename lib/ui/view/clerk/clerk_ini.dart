import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';

class Clerk extends StatefulWidget {
  final Employee emp;

  const Clerk({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClerkState();
}

class _ClerkState extends State<Clerk> {
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
