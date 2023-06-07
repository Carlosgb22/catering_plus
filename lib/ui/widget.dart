import 'dart:io';

import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/login_provider.dart';
import 'package:catering_plus/ui/view/admin/admin_ini.dart';
import 'package:catering_plus/ui/view/admin/manage_emp_profile.dart';
import 'package:catering_plus/ui/view/employee/event_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/models/event_model.dart';
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
    if (Platform.isAndroid || Platform.isIOS) {
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
              size: 30,
            ),
            Column(
              children: [
                //Texto que indica el nombre del empleado
                Text("Nombre: ${employee.familyName}, ${employee.name}"),
                //Texto que indica el DNI del empleado
                Text("DNI: ${employee.dni}"),
              ],
            ),
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
    } else {
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
                deleteLogin(employee.dni);
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
}

class LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const LegendItem({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

Widget buildEventCard(context, Event event) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventView(event: event),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fecha del evento:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd-MM-yyyy').format(event.date),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lugar:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  event.place,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
