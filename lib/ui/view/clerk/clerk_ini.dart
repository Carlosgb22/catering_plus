import 'package:catering_plus/ui/view/clerk/place_view.dart';
import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/models/event_model.dart';
import '../../../core/models/place_model.dart';
import '../../../core/provider/event_provider.dart';
import '../../../core/provider/place_provider.dart';
import '../../../core/provider/session_provider.dart';
import '../../widget.dart';
import 'add_event.dart';
import 'add_place.dart';

class Clerk extends StatefulWidget {
  final Employee emp;

  const Clerk({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClerkState();
}

class _ClerkState extends State<Clerk> {
  late Employee emp;
  DateTime currentDate = DateTime.now();
  final List<String> options = ['Eventos', 'Lugares'];
  String selectedOption = 'Eventos';

  @override
  void initState() {
    super.initState();
    emp = widget.emp;
  }

  List<Event> getEventsByCategory(List<Event> events, int revised) {
    final filteredEvents = events.where((event) {
      if (revised == 0) {
        return event.revised == 0 && event.date.isBefore(currentDate);
      } else if (revised == 1) {
        return event.revised == 1 && event.date.isBefore(currentDate);
      } else {
        return event.date.isAfter(currentDate);
      }
    }).toList();

    filteredEvents.sort((a, b) => a.date.compareTo(b.date));

    return filteredEvents;
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    // Determinar qué cuerpo mostrar según la opción seleccionada
    if (selectedOption == 'Eventos') {
      bodyWidget = FutureBuilder<List<Event>>(
        future: getAllEvents(emp.idCatering),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los eventos'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay eventos disponibles'),
            );
          } else {
            final events = snapshot.data!;
            final eventsToReview = getEventsByCategory(events, 0).toList();
            final upcomingEvents = getEventsByCategory(events, -1).toList();
            final reviewedEvents = getEventsByCategory(events, 1).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Eventos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      buildCategoryWidget("A revisar", eventsToReview,
                          eventsToReview.isNotEmpty, emp),
                      buildCategoryWidget("Próximos", upcomingEvents,
                          upcomingEvents.isNotEmpty, emp),
                      buildCategoryWidget(
                        "Revisados",
                        reviewedEvents,
                        reviewedEvents.isNotEmpty,
                        emp,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      );
    } else {
      bodyWidget = FutureBuilder<List<Place>>(
          future: getAllPlaces(emp.idCatering),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error al cargar los lugares'),
              );
            } else if (snapshot.hasData) {
              List<Place> places = snapshot.data!;
              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  Place place = places[index];
                  final backgroundColor =
                      index % 2 == 0 ? Colors.white : Colors.grey[200];
                  return Container(
                    color: backgroundColor,
                    child: ListTile(
                        title: Text(
                          place.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deletePlace(place.name);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceView(place: place),
                              ));
                        }),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No se encontraron lugares'),
              );
            }
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido ${emp.name}"),
        actions: [
          IconButton(
            onPressed: () {
              closeSession(context);
            },
            icon: const Icon(Icons.logout),
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return options.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
            initialValue: selectedOption,
            onSelected: (String option) {
              setState(() {
                selectedOption = option;
              });
            },
          ),
        ],
      ),
      body: bodyWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => selectedOption == 'Eventos'
                    ? AddEvent(emp: emp)
                    : AddPlace(emp: emp),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
