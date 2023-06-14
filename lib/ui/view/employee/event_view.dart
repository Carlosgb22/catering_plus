import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../core/models/place_model.dart';
import '../../../core/models/event_model.dart';
import '../../widget.dart';

class EventView extends StatefulWidget {
  final Event event;

  const EventView({super.key, required this.event});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  late Event event;
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
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
        body: FutureBuilder<Place>(
          future: getPlaceById(event.place),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Fecha del evento:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(event.date),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Lugar del evento:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      event.place,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dirección:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: toggleMap,
                      child: const Text('Ver Mapa'),
                    )
                  ],
                ),
              );
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
        ),
      );
    }
  }
}
