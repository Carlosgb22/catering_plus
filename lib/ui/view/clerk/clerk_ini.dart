import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/provider/session_provider.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Bienvenido ${emp.name}"),
          actions: [
            IconButton(
              onPressed: () {
                closeSession(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Container());
  }
}
