// ignore_for_file: use_build_context_synchronously

import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/models/work_model.dart';
import 'package:catering_plus/core/provider/event_provider.dart';
import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:catering_plus/ui/view/clerk/clerk_ini.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/event_model.dart';
import '../../../core/provider/employee_provider.dart';
import '../../../core/provider/work_provider.dart';
import '../../widget.dart';

class AddEvent extends StatefulWidget {
  final Employee emp;
  const AddEvent({Key? key, required this.emp}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late SharedPreferences sharedPreferences;
  late Employee emp;
  late Event event;
  late DateTime selectedDate;
  List<String> places = [];
  late String place;
  late TextEditingController phone1Controller;
  late TextEditingController phone2Controller;
  late int assemblyHours;
  late int serviceHours;
  late int openBarHours;
  late TextEditingController dateController;

  List<Employee> selectedEmployees = [];
  List<bool> isMaster = [];
  List<bool> isAssembly = [];
  List<bool> isService = [];
  List<bool> isOpenBar = [];

  @override
  void initState() {
    super.initState();
    emp = widget.emp;
    phone1Controller = TextEditingController();
    phone2Controller = TextEditingController();
    assemblyHours = 0;
    serviceHours = 0;
    openBarHours = 0;
    dateController = TextEditingController();
    getPlacesNames(emp.idCatering).then((List<String> names) {
      setState(() {
        places = names;
        place = places.isNotEmpty ? places[0] : '';
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

  void _updateSelectedEmployees(Employee employee, bool isMaster,
      bool isAssembly, bool isService, bool isOpenBar) {
    setState(() {
      selectedEmployees.add(employee);
      this.isMaster.add(isMaster);
      this.isAssembly.add(isAssembly);
      this.isService.add(isService);
      this.isOpenBar.add(isOpenBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear Evento'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                              selectedDate =
                                  await _selectDate(context, DateTime.now());
                              setState(() {
                                dateController.text = DateFormat('dd-MM-yyyy')
                                    .format(selectedDate);
                              });
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextField(
                                    enabled: false,
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                ),
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
                          selectedIndex: places.indexOf(place),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              place = places[index!];
                            });
                          },
                          items: places.map((String value) {
                            return MySelectionItem(
                              title: value,
                            );
                          }).toList(),
                          child: MySelectionItem(
                            isForList: false,
                            title: place,
                          ),
                        ),
                      ],
                    ),
                    buildTextFieldRow(
                      'Teléfono 1:',
                      '',
                      controller: phone1Controller,
                    ),
                    buildTextFieldRow(
                      'Teléfono 2:',
                      '',
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
                    const SizedBox(height: 10),
                    const Text(
                      'Empleados Asignados',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedEmployees.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Última tarjeta con el botón de añadir
                            return GestureDetector(
                              onTap: () {
                                _showAddEmployeeDialog(context);
                              },
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Icon(Icons.add, size: 60),
                                ),
                              ),
                            );
                          }

                          final employee = selectedEmployees[index - 1];
                          final isMaster = this.isMaster[index - 1];
                          final isAssembly = this.isAssembly[index - 1];
                          final isService = this.isService[index - 1];
                          final isOpenBar = this.isOpenBar[index - 1];

                          return SizedBox(
                              width: 200, // ancho deseado para la tarjeta
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                          '${employee.name} ${employee.familyName}'),
                                      IconButton(
                                          onPressed: () {
                                            int deleteIndex = selectedEmployees
                                                .indexOf(employee);
                                            setState(() {
                                              selectedEmployees
                                                  .removeAt(deleteIndex);
                                              this
                                                  .isMaster
                                                  .removeAt(deleteIndex);
                                              this
                                                  .isAssembly
                                                  .removeAt(deleteIndex);
                                              this
                                                  .isService
                                                  .removeAt(deleteIndex);
                                              this
                                                  .isOpenBar
                                                  .removeAt(deleteIndex);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Metre: ${isMaster ? 'Sí' : 'No'}'),
                                      Text(
                                          'Montaje: ${isAssembly ? 'Sí' : 'No'}'),
                                      Text(
                                          'Servicio: ${isService ? 'Sí' : 'No'}'),
                                      Text(
                                          'Barra Libre: ${isOpenBar ? 'Sí' : 'No'}'),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: MediaQuery.of(context).size.width * 0.30,
              right: MediaQuery.of(context).size.width * 0.30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      createEvent();
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  createEvent() async {
    if (!isMaster.contains(true)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Por favor, uno de los empleados tiene que ser el metre.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    if (dateController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor, selecciona una fecha.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    if (place.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor, selecciona un lugar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    if (phone1Controller.text.isEmpty || phone1Controller.text.length != 9) {
      // Teléfono 1 debe tener 9 dígitos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('El teléfono 1 debe tener 9 dígitos.'),
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

    if (phone2Controller.text.isNotEmpty && phone2Controller.text.length != 9) {
      // Teléfono 2 debe tener 9 dígitos si está presente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('El teléfono 2 debe tener 9 dígitos.'),
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

    event = Event(
      idCatering: emp.idCatering,
      date: event.date = DateTime.parse(
          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(selectedDate)),
      phone1: int.tryParse(phone1Controller.text) ?? 0,
      place: place,
      assemblyHours: assemblyHours,
      serviceHours: serviceHours,
      openBarHours: openBarHours,
      revised: 0,
    );
    event.phone2 = int.tryParse(phone2Controller.text) ?? 0;
    var id = await addEvent(event);

    for (int i = 0; i < selectedEmployees.length; i++) {
      final employee = selectedEmployees[i];
      final master = isMaster[i];
      final assembly = isAssembly[i];
      final service = isService[i];
      final openBar = isOpenBar[i];

      await addWork(Work(
        dni: employee.dni,
        eventId: id,
        idCatering: emp.idCatering,
        master: master ? 1 : 0,
        assembly: assembly ? 1 : 0,
        service: service ? 1 : 0,
        openBar: openBar ? 1 : 0,
      ));
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Clerk(emp: emp)),
      (route) => false,
    );
  }

  Future<void> _showAddEmployeeDialog(BuildContext context) async {
    final employees =
        await getAllEmployees(emp.idCatering); // Obtener lista de empleados

    Employee? selectedEmployee; // Empleado seleccionado
    bool isMasterSelected = false; // Checkbox para Metre
    bool isAssemblySelected = false; // Checkbox para Montaje
    bool isServiceSelected = true; // Checkbox para Servicio
    bool isOpenBarSelected = false; // Checkbox para Barra Libre

    // Filtrar empleados según los campos 'admin' y 'clerk', y si no están en selectedEmployees
    final filteredEmployees = employees
        .where((employee) =>
            employee.admin == 0 &&
            employee.clerk == 0 &&
            !selectedEmployees.contains(employee))
        .toList();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Añadir Empleado'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<Employee>(
                    value: selectedEmployee,
                    hint: const Text('Seleccionar empleado'),
                    onChanged: (Employee? newValue) {
                      setState(() {
                        selectedEmployee = newValue;
                      });
                    },
                    items: filteredEmployees.map((Employee employee) {
                      return DropdownMenuItem<Employee>(
                        value: employee,
                        child: Text('${employee.name} ${employee.familyName}'),
                      );
                    }).toList(),
                  ),
                  CheckboxListTile(
                    value: isMasterSelected,
                    onChanged: (value) {
                      setState(() {
                        isMasterSelected = value ?? false;
                      });
                    },
                    title: const Text('Metre'),
                  ),
                  CheckboxListTile(
                    value: isAssemblySelected,
                    onChanged: (value) {
                      setState(() {
                        isAssemblySelected = value ?? false;
                      });
                    },
                    title: const Text('Montaje'),
                  ),
                  CheckboxListTile(
                    value: isServiceSelected,
                    onChanged: (value) {
                      setState(() {
                        isServiceSelected = value ?? false;
                      });
                    },
                    title: const Text('Servicio'),
                  ),
                  CheckboxListTile(
                    value: isOpenBarSelected,
                    onChanged: (value) {
                      setState(() {
                        isOpenBarSelected = value ?? false;
                      });
                    },
                    title: const Text('Barra Libre'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedEmployee != null) {
                      _updateSelectedEmployees(
                        selectedEmployee!,
                        isMasterSelected,
                        isAssemblySelected,
                        isServiceSelected,
                        isOpenBarSelected,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Añadir'),
                ),
              ],
            );
          },
        );
      },
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
