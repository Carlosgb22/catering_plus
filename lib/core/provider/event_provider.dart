import 'package:catering_plus/core/models/event_model.dart';

import '../services/event_service.dart';

Future<Event> getEvent(int id) {
  return getEventByIdHttp(id);
}

Future<List<Event>> getAllEvents(int idCatering) {
  return getAllEventsHttp(idCatering);
}

deleteEvent(int id) {
  deleteEventHttp(id);
}

updateEvent(Event event) {
  updateEventHttp(event);
}

Future<int> addEvent(Event event) {
  return addEventHttp(event);
}
