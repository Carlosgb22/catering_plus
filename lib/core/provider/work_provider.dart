import 'package:catering_plus/core/models/work_model.dart';
import 'package:catering_plus/core/provider/event_provider.dart';

import '../models/event_model.dart';
import '../services/work_service.dart';

Future<Work> getWork(String dni, int id) {
  return getWorkByIdHttp(dni, id);
}

Future<List<Event>> getEventsInWork(String dni) async {
  List<Event> eventList = [];
  List<Work> works = await getAllWorks(dni);
  for (var work in works) {
    eventList.add(await getEvent(work.eventId));
  }
  return eventList;
}

Future<List<Work>> getAllWorks(String dni) {
  return getAllWorksHttp(dni);
}

deleteWork(String dni, int id) {
  deleteWorkHttp(dni, id);
}

updateWork(Work work) {
  updateWorkHttp(work);
}

addWork(Work work) {
  addWorkHttp(work);
}
