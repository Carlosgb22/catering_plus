import 'package:catering_plus/core/models/event_model.dart';
import 'package:catering_plus/core/provider/work_provider.dart';

import '../models/work_model.dart';
import '../services/event_service.dart';

Future<Event> getEvent(int id) {
  return getEventByIdHttp(id);
}

Future<List<Event>> getAllEvents(int idCatering) {
  return getAllEventsHttp(idCatering);
}

deleteEvent(int id) async {
  List<Work> works = await getAllWorksId(id);
  for (var work in works) {
    deleteWork(work.dni, work.eventId);
  }
  deleteEventHttp(id);
}

updateEvent(Event event) {
  updateEventHttp(event);
}

Future<int> addEvent(Event event) {
  return addEventHttp(event);
}
