import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/place_model.dart';
import '../../../core/models/event_model.dart';

class EventView extends StatefulWidget {
  final Event event;

  const EventView({super.key, required this.event});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  late Event event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
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
            final place = snapshot.data!;

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
                  SizedBox(
                      height: 500, child: buildMap(getPlaceMap(place.address))),
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

  Widget buildMap(LatLng eventLocation) {
    return FlutterMap(
      options: MapOptions(
        center: eventLocation,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }
}
