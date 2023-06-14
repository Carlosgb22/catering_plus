import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:catering_plus/ui/view/clerk/update_event.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/models/place_model.dart';
import '../../../core/models/event_model.dart';
import '../../widget.dart';

class ClerkEventView extends StatefulWidget {
  final Event event;
  final Employee emp;

  const ClerkEventView({Key? key, required this.event, required this.emp})
      : super(key: key);

  @override
  State<ClerkEventView> createState() => _ClerkEventViewState();
}

class _ClerkEventViewState extends State<ClerkEventView> {
  late Event event;
  late Employee emp;
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    emp = widget.emp;
  }

  void toggleMap() {
    setState(() {
      showMap = !showMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showMap) {
      final placeFuture = getPlaceById(event.place);

      return FutureBuilder<Place>(
        future: placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final place = snapshot.data!;

            return buildMap(getPlaceMap(place.address), toggleMap);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar el lugar del evento'),
            );
          } else {
            return const Center(
              child: Text('No se encontró el lugar del evento'),
            );
          }
        },
      );
    } else {
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
                buildEventDetailRow(
                  'Fecha del evento:',
                  DateFormat('dd-MM-yyyy').format(event.date),
                ),
                buildEventDetailRow(
                  'Lugar del evento:',
                  event.place,
                ),
                buildEventDetailRow(
                  'Teléfono 1:',
                  event.phone1.toString(),
                ),
                if (event.phone2 != null && event.phone2 != 0)
                  buildEventDetailRow(
                    'Teléfono 2:',
                    event.phone2.toString(),
                  ),
                buildEventDetailRow(
                  'Montaje:',
                  '${event.assemblyHours.toString()} horas',
                ),
                buildEventDetailRow(
                  'Servicio:',
                  '${event.serviceHours.toString()} horas',
                ),
                buildEventDetailRow(
                  'Barra Libre:',
                  '${event.openBarHours.toString()} horas',
                ),
                const SizedBox(height: 20),
                buildEventDetailRow(
                  'Revisado:',
                  event.revised == 1 ? 'Sí' : 'No',
                ),
                const SizedBox(height: 40),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: toggleMap,
                    child: const Text('Ver Mapa'),
                  )
                ]),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateEvent(event: event, emp: emp),
                ));
          },
          child: const Icon(Icons.edit),
        ),
      );
    }
  }
}
