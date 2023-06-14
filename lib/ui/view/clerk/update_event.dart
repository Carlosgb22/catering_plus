// ignore_for_file: unnecessary_null_comparison

import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/event_provider.dart';
import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:catering_plus/core/services/employee_service.dart';
import 'package:catering_plus/ui/view/clerk/clerk_ini.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/event_model.dart';
import '../../widget.dart';

class UpdateEvent extends StatefulWidget {
  final Event event;
  final Employee emp;

  const UpdateEvent({Key? key, required this.event, required this.emp})
      : super(key: key);

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  late Event event;
  late Employee emp;
  late TextEditingController phone1Controller;
  late TextEditingController phone2Controller;
  late int assemblyHours;
  late int serviceHours;
  late int openBarHours;
  late TextEditingController dateController;
  late bool revised;
  List<String> places = [];

  @override
  void initState() {
    super.initState();
    event = widget.event;
    emp = widget.emp;
    phone1Controller = TextEditingController(text: event.phone1.toString());
    phone2Controller = TextEditingController(
        text: event.phone2 != 0 ? event.phone2.toString() : '');
    assemblyHours = event.assemblyHours;
    serviceHours = event.serviceHours;
    openBarHours = event.openBarHours;
    revised = event.revised == 1;
    dateController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(event.date));
    getPlacesNames(emp.idCatering).then((List<String> names) {
      setState(() {
        places = names;
      });
    });
  }

  @override
  void dispose() {
    phone1Controller.dispose();
    phone2Controller.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;
    Employee emp;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del evento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final newDate = await _selectDate(context, event.date);
                        setState(() {
                          event.date = newDate;
                          dateController.text =
                              DateFormat('dd-MM-yyyy').format(event.date);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: TextField(
                                  enabled: false,
                                  controller: dateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(10.0),
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text('Lugar: ', style: TextStyle(fontSize: 20)),
                  DirectSelect(
                    itemExtent: 40.0,
                    selectedIndex: places.indexOf(event.place),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        event.place = places[index!];
                      });
                    },
                    items: places.map((String value) {
                      return MySelectionItem(
                        title: value,
                      );
                    }).toList(),
                    child: MySelectionItem(
                      isForList: false,
                      title: event.place,
                    ),
                  )
                ],
              ),
              buildTextFieldRow(
                'Teléfono 1:',
                phone1Controller.text,
                controller: phone1Controller,
              ),
              if (event.phone2 != null && event.phone2 != 0)
                buildTextFieldRow(
                  'Teléfono 2:',
                  phone2Controller.text,
                  controller: phone2Controller,
                ),
              buildNumberPickerRow(
                'Montaje:',
                assemblyHours,
                onChanged: (value) {
                  setState(() {
                    assemblyHours = value;
                  });
                },
              ),
              buildNumberPickerRow(
                'Servicio:',
                serviceHours,
                onChanged: (value) {
                  setState(() {
                    serviceHours = value;
                  });
                },
              ),
              buildNumberPickerRow(
                'Barra Libre:',
                openBarHours,
                onChanged: (value) {
                  setState(() {
                    openBarHours = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildCheckboxRow(
                'Revisado',
                revised,
                onChanged: (value) {
                  setState(() {
                    revised = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Validar las restricciones
                      if (event.date == null) {
                        // Fecha no puede ser nula
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('La fecha no puede estar vacía.'),
                              actions: [
                                TextButton(
                                  child: const Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return; // Detener el flujo de ejecución
                      }

                      if (event.place.isEmpty) {
                        // Lugar no puede estar vacío
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('El lugar no puede estar vacío.'),
                              actions: [
                                TextButton(
                                  child: const Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return; // Detener el flujo de ejecución
                      }

                      if (phone1Controller.text.isEmpty ||
                          phone1Controller.text.length != 9) {
                        // Teléfono 1 debe tener 9 dígitos
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'El teléfono 1 debe tener 9 dígitos.'),
                              actions: [
                                TextButton(
                                  child: const Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return; // Detener el flujo de ejecución
                      }

                      if (phone2Controller.text.isNotEmpty &&
                          phone2Controller.text.length != 9) {
                        // Teléfono 2 debe tener 9 dígitos si está presente
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'El teléfono 2 debe tener 9 dígitos.'),
                              actions: [
                                TextButton(
                                  child: const Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return; // Detener el flujo de ejecución
                      }

                      // Resto del código para actualizar el evento
                      event.assemblyHours = assemblyHours;
                      event.serviceHours = serviceHours;
                      event.openBarHours = openBarHours;
                      event.revised = revised ? 1 : 0;
                      event.date = DateTime.parse(
                          DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                              .format(event.date));
                      updateEvent(event);
                      sharedPreferences = await SharedPreferences.getInstance();
                      emp = await getEmployeeByIdHttp(
                          sharedPreferences.getString('dni'));
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Clerk(emp: emp)),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime> _selectDate(
    BuildContext context, DateTime selectedDate) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    return pickedDate;
  } else {
    return selectedDate;
  }
}
