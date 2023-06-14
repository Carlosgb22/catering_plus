import 'package:catering_plus/core/config/config.dart';
import 'package:dio/dio.dart';

import '../models/event_model.dart';

final dio = Dio();

Future<Event> getEventByIdHttp(id) async {
  var response = await dio.get("http://$ip:$port/event/$id");
  if (response.statusCode == 200) {
    return Event.fromJson(response.data);
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<List<Event>> getAllEventsHttp(idCatering) async {
  var response = await dio.get("http://$ip:$port/event/all/$idCatering");
  if (response.statusCode == 200) {
    response.data;
    final eventList =
        (response.data as List).map((e) => Event.fromJson(e)).toList();
    return eventList;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<int> addEventHttp(Event event) async {
  var response = await dio.post("http://$ip:$port/event/add",
      data: event.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Error al añadir Evento');
  }
}

updateEventHttp(Event event) async {
  await dio.post("http://$ip:$port/event/${event.id}/update",
      data: event.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

deleteEventHttp(id) async {
  await dio.delete("http://$ip:$port/event/$id");
}
