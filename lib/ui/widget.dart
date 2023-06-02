import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/ui/view/admin/admin_ini.dart';
import 'package:catering_plus/ui/view/admin/manage_emp_profile.dart';
import 'package:flutter/material.dart';

import '../core/provider/employee_provider.dart';

class EmployeeButton extends StatelessWidget {
  final Employee employee;
  final Employee emp;
  //Se le pasa un empleado con el cual se generará el boton
  const EmployeeButton({super.key, required this.employee, required this.emp});

  @override
  Widget build(BuildContext context) {
    Color getButtonColor() {
      if (employee.admin == 1) {
        return Colors.red.shade100;
      } else if (employee.clerk == 1) {
        return Colors.blue.shade100;
      } else {
        return Colors.green.shade100;
      }
    }

    //Devuelve un boton
    return TextButton(
      style: TextButton.styleFrom(
          side: const BorderSide(width: 3.0),
          textStyle: const TextStyle(fontSize: 15),
          backgroundColor: getButtonColor()),
      //Tiene una fila que se expande al ancho disponible de la pantalla
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //Lista de items que tiene la fila
        children: [
          //Icono proporcionado por flutter
          Icon(
            Icons.person,
            color: Colors.blueGrey.shade400,
            size: 60,
          ),
          //Texto que indica el nombre del empleado
          Text("Nombre: ${employee.familyName}, ${employee.name}"),
          //Texto que indica el DNI del empleado
          Text("DNI: ${employee.dni}"),
          //Boton con icono de una papelera proporcionado por flutter
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            //Cuando pulsas la papelera se borra el empleado indicado
            onPressed: () {
              deleteEmployee(employee.dni);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Admin(emp: emp)),
                  (route) => false);
            },
          ),
        ],
      ),
      //Cuando pulsas el resto de la fila te muestra una pestaña con los detalles del empleado
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmployeeProfile(
                    employee: employee,
                    emp: emp,
                  ))),
    );
  }
}