// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:catering_plus/ui/view/clerk/clerk_event_view.dart';
import 'package:catering_plus/ui/view/clerk/update_event.dart';
import 'package:catering_plus/ui/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/ui/view/admin/manage_emp_profile.dart';
import 'package:catering_plus/ui/view/employee/event_view.dart';

import '../core/models/event_model.dart';
import '../core/provider/employee_provider.dart';
import '../core/provider/event_provider.dart';

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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        '¿Está seguro de que desea borrar este empleado?.\nEsta accion es irreversible'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                              (route) => false);
                          deleteEmployee(employee.dni);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        '¿Está seguro de que desea borrar este empleado?.\nEsta accion es irreversible'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                              (route) => false);
                          deleteEmployee(employee.dni);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
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

Widget buildEventDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        SizedBox(
          width: 120.0,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget buildMap(LatLng eventLocation, Function() toggleMap) {
  return GestureDetector(
    child: Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlutterMap(
                options: MapOptions(
                  center: eventLocation,
                ),
                nonRotatedChildren: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    additionalOptions: const {
                      'userAgent': 'com.example.app',
                    },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: eventLocation,
                        builder: (ctx) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.red,
              onPressed: toggleMap,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildTextFieldRow(String label, String value,
    {TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          keyboardType: label.compareTo('Teléfono 1:') == 0 ||
                  label.compareTo('Teléfono 2:') == 0
              ? TextInputType.number
              : TextInputType.text,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(10.0),
          ),
        ),
      ],
    ),
  );
}

Widget buildCheckboxRow(String label, bool value,
    {ValueChanged<bool>? onChanged}) {
  return Row(
    children: [
      Checkbox(
        value: value,
        onChanged:
            onChanged != null ? (newValue) => onChanged(newValue!) : null,
      ),
      Text(label),
    ],
  );
}

Widget buildNumberPickerRow(
  String label,
  int value, {
  required ValueChanged<int> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        NumberPicker(
          value: value,
          minValue: 0,
          maxValue: 24,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

class NumberPicker extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const NumberPicker({
    Key? key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_value > widget.minValue) {
                _value--;
                widget.onChanged(_value);
              }
            });
          },
        ),
        Text('$_value'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (_value < widget.maxValue) {
                _value++;
                widget.onChanged(_value);
              }
            });
          },
        ),
      ],
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem(
      {super.key, required this.title, this.isForList = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isForList ? 16.0 : 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

Widget buildCategoryWidget(
  String category,
  List<Event> events,
  bool hasEvents,
  Employee emp,
) {
  return ExpansionTile(
    initiallyExpanded: hasEvents && category == "A revisar",
    title: Row(
      children: [
        if (category == "A revisar" && hasEvents)
          const Icon(Icons.warning, color: Colors.red),
        const SizedBox(width: 8),
        Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    children: [
      if (!hasEvents)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("No hay eventos disponibles"),
        ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final isEvenItem = index % 2 == 0;
          final backgroundColor = isEvenItem ? Colors.white : Colors.grey[200];
          final canEditEvent = category !=
              "Revisados"; // Permitir editar solo en categorías diferentes a "Revisados"
          return Container(
            color: backgroundColor,
            child: ListTile(
              title: Text(
                event.place,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy').format(event.date),
              ),
              trailing: canEditEvent
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateEvent(event: event, emp: emp),
                            ));
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                '¿Está seguro de que desea borrar este evento?.\nEsta accion es irreversible'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                      (route) => false);
                                  deleteEvent(event.id!);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClerkEventView(event: event, emp: emp),
                    ));
              },
            ),
          );
        },
      ),
    ],
  );
}
