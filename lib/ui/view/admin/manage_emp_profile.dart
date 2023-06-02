import 'package:catering_plus/core/models/employee_model.dart';
import 'package:flutter/material.dart';

import 'update_employee.dart';

class EmployeeProfile extends StatefulWidget {
  final Employee employee;
  final Employee emp;

  const EmployeeProfile({Key? key, required this.employee, required this.emp})
      : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  late Employee _employee;
  late Employee _emp;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _emp = widget.emp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos del Empleado"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //DATOS
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Información del Empleado",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "${_employee.name} ${_employee.familyName}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "DNI: ${_employee.dni}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Teléfono: ${_employee.phone}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "SS: ${_employee.ss}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.work,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            "Gestor",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: _employee.clerk == 0 ? false : true,
                            onChanged: (bool? value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //BOTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateEmployee(employee: _employee, emp: _emp),
                    ),
                  );
                },
                child: const Text(
                  "Actualizar datos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
