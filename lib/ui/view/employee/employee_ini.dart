import 'dart:io';

import 'package:catering_plus/ui/view/employee/update_profile.dart';
import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/models/event_model.dart';
import '../../../core/provider/session_provider.dart';
import '../../../core/provider/work_provider.dart';
import '../../widget.dart';

class EmployeeView extends StatefulWidget {
  final Employee emp;

  const EmployeeView({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeView> {
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
      body: Column(
        children: [
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfile(emp: emp),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blueGrey.shade400,
                      size: 30,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Platform.isAndroid | Platform.isIOS
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${emp.name}',
                                    style: const TextStyle(fontSize: 20)),
                                Text('Apellidos: ${emp.familyName}',
                                    style: const TextStyle(fontSize: 20)),
                                Text('DNI: ${emp.dni}',
                                    style: const TextStyle(fontSize: 20)),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${emp.name}',
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(
                                  width: 50,
                                ),
                                Text('Apellidos: ${emp.familyName}',
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(
                                  width: 50,
                                ),
                                Text('DNI: ${emp.dni}',
                                    style: const TextStyle(fontSize: 20)),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Eventos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: getEventsInWork(emp.dni),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar los eventos');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay eventos disponibles');
                } else {
                  final now = DateTime.now();
                  final upcomingEvents = snapshot.data!
                      .where((event) => event.date.isAfter(now))
                      .toList();
                  final pastEvents = snapshot.data!
                      .where((event) => event.date.isBefore(now))
                      .toList();
                  return ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Próximos Eventos:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (upcomingEvents.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: upcomingEvents.length,
                              itemBuilder: (context, index) {
                                Event event = upcomingEvents[index];
                                return buildEventCard(context, event);
                              },
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No hay próximos eventos',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Eventos Realizados:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (pastEvents.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pastEvents.length,
                              itemBuilder: (context, index) {
                                Event event = pastEvents[index];
                                return buildEventCard(context, event);
                              },
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No hay eventos realizados',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
