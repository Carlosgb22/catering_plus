import 'package:flutter/material.dart';

import '../../../core/models/place_model.dart';
import '../../../core/provider/place_provider.dart';
import '../../widget.dart';

class PlaceView extends StatefulWidget {
  final Place place;

  const PlaceView({super.key, required this.place});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  late Place place;
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }

  void toggleMap() {
    setState(() {
      showMap = !showMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showMap) {
      return FutureBuilder<Place>(
        future: Future(() => place),
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
          title: Text(place.name),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.phone,
                size: 50,
              ),
              title: const Text('Telefono',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text(place.phone.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  )),
            ),
            GestureDetector(
                onTap: toggleMap,
                child: const ListTile(
                  leading: Icon(
                    Icons.map,
                    size: 50,
                  ),
                  title: Text('Direccion',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  subtitle: Text('Toca para ver el mapa',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                )),
          ],
        ),
      );
    }
  }
}
