import 'package:catering_plus/core/provider/session_provider.dart';
import 'package:catering_plus/ui/view/admin/add_employee.dart';
import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/provider/employee_provider.dart';
import '../../widget.dart';

class Admin extends StatefulWidget {
  final Employee emp;

  const Admin({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late Employee emp;
  late Future<List<Employee>> _employeeList;

  @override
  void initState() {
    super.initState();
    emp = widget.emp;
    _employeeList = getAllEmployees(emp.idCatering);
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.yellow, // Color de la leyenda
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LegendItem(
                  text: 'Administrador',
                  color: Colors.red.shade200,
                ),
                const SizedBox(width: 16),
                LegendItem(
                  text: 'Gestor',
                  color: Colors.blue.shade200,
                ),
                const SizedBox(width: 16),
                LegendItem(
                  text: 'Trabajador',
                  color: Colors.green.shade200,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Employee>>(
              future: _employeeList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Employee> list = <Employee>[];
                  for (var data in snapshot.data!) {
                    list.add(Employee(
                      dni: data.dni,
                      idCatering: data.idCatering,
                      name: data.name,
                      familyName: data.familyName,
                      phone: data.phone,
                      ss: data.ss,
                      clerk: data.clerk,
                      admin: data.admin,
                    ));
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ListTile(
                        title: EmployeeButton(employee: item, emp: emp),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occurred: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployee(emp: emp),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}
