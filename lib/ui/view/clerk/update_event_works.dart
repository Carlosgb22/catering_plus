// ignore_for_file: use_build_context_synchronously

import 'package:catering_plus/core/provider/work_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/models/work_model.dart';
import '../../../core/provider/employee_provider.dart';

class UpdateWorks extends StatefulWidget {
  final int eventId;
  final Employee emp;

  const UpdateWorks({super.key, required this.eventId, required this.emp});

  @override
  State<UpdateWorks> createState() => _UpdateWorksState();
}

class _UpdateWorksState extends State<UpdateWorks> {
  late List<Work> works;
  late List<Employee> selectedEmployees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Empleados del Evento'),
        ),
        body: Container(
            // Envuelve el Column con un Container
            // Puedes ajustar los valores de padding o constraints según tus necesidades
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(
              minWidth: double
                  .infinity, // Ancho mínimo para ocupar todo el espacio disponible
              minHeight: double
                  .infinity, // Alto mínimo para ocupar todo el espacio disponible
            ),
            child: Column(
              children: [
                Expanded(
                  // Agrega Expanded para que el ListView ocupe el espacio restante
                  child: FutureBuilder(
                    future: getAllWorksId(widget.eventId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Muestra un indicador de carga mientras se obtiene la lista de trabajos
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Muestra un mensaje de error si ocurre algún error durante la obtención de los trabajos
                        return Text('Error: ${snapshot.error}');
                      } else {
                        works = snapshot.data!;
                        return ListView.builder(
                          itemCount: works.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<Employee>(
                              future: getEmployee(works[index].dni),
                              builder: (context, employeeSnapshot) {
                                if (employeeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Muestra un indicador de carga mientras se obtiene el empleado
                                  return const CircularProgressIndicator();
                                } else if (employeeSnapshot.hasError) {
                                  // Muestra un mensaje de error si ocurre algún error durante la obtención del empleado
                                  return Text(
                                      'Error: ${employeeSnapshot.error}');
                                } else if (employeeSnapshot.hasData) {
                                  Employee employee = employeeSnapshot.data!;
                                  selectedEmployees.add(employee);
                                  final isMaster = works[index].master;
                                  final isAssembly = works[index].assembly;
                                  final isService = works[index].service;
                                  final isOpenBar = works[index].openBar;
                                  return Container(
                                    color: index % 2 == 0
                                        ? Colors.white
                                        : Colors.grey[200],
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${employee.name} ${employee.familyName}'),
                                          IconButton(
                                              onPressed: () {
                                                deleteWork(employee.dni,
                                                    widget.eventId);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateWorks(
                                                              eventId: widget
                                                                  .eventId,
                                                              emp: widget.emp),
                                                    ));
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Metre: ${isMaster == 1 ? 'Sí' : 'No'}'),
                                          Text(
                                              'Montaje: ${isAssembly == 1 ? 'Sí' : 'No'}'),
                                          Text(
                                              'Servicio: ${isService == 1 ? 'Sí' : 'No'}'),
                                          Text(
                                              'Barra Libre: ${isOpenBar == 1 ? 'Sí' : 'No'}'),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  // No hay datos disponibles para mostrar
                                  return const SizedBox.shrink();
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () => _showAddEmployeeDialog(context),
                  icon: const Icon(Icons.person_add),
                ),
              ],
            )));
  }

  Future<void> _showAddEmployeeDialog(BuildContext context) async {
    final employees = await getAllEmployees(
        widget.emp.idCatering); // Obtener lista de empleados

    Employee? selectedEmployee; // Empleado seleccionado
    bool isMasterSelected = false; // Checkbox para Metre
    bool isAssemblySelected = false; // Checkbox para Montaje
    bool isServiceSelected = true; // Checkbox para Servicio
    bool isOpenBarSelected = false; // Checkbox para Barra Libre

    final filteredEmployees = employees.where((employee) {
      if (employee.admin != 0 ||
          employee.clerk != 0 ||
          selectedEmployees.contains(employee)) {
        return false; // No se muestra si admin o clerk no es igual a 0
      } else {
        return true;
      }
    }).toList();

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
                      _addEmployees(
                        selectedEmployee!,
                        isMasterSelected,
                        isAssemblySelected,
                        isServiceSelected,
                        isOpenBarSelected,
                      );
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateWorks(
                                eventId: widget.eventId, emp: widget.emp),
                          ));
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

  void _addEmployees(Employee employee, bool isMaster, bool isAssembly,
      bool isService, bool isOpenBar) {
    addWork(
      Work(
          dni: employee.dni,
          eventId: widget.eventId,
          idCatering: widget.emp.idCatering,
          master: isMaster ? 1 : 0,
          assembly: isAssembly ? 1 : 0,
          service: isService ? 1 : 0,
          openBar: isOpenBar ? 1 : 0),
    );
  }
}
