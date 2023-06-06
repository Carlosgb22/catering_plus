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
          title: const Text("Empleados"),
          actions: [
            IconButton(
                onPressed: () {
                  closeSession(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        //FutureBuilder que recibe los empleados
        body: FutureBuilder<List<Employee>>(
            future: _employeeList,
            builder: (context, snapshot) {
              //snapshot seria el futuro, si tiene datos se muestran los empleados en un ListView
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
                      admin: data.admin));
                }
                return ListView.builder(
                  // Deja que ListView sepa cuántos elementos necesita para construir
                  itemCount: list.length,
                  // Proporciona una función de constructor. Se crea un dispositivo por cada elemento
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      //EmployeeButton es un widget personalizado el cual se encutra en widget.dart
                      title: EmployeeButton(employee: item, emp: emp),
                    );
                  },
                );
                //Si snapshot tiene errores, te muestra el error en el centro
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('An error occurred: ${snapshot.error}'),
                );
                //En el caso de tardar mucho te muestra un indicador de carga
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        //Te muestra un boton flotante con el simbolo + el cual te permite añadir un empleado
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddEmployee(emp: emp)));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.person_add_alt_1),
        ));
  }
}
