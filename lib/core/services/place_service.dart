import 'package:catering_plus/core/config/config.dart';
import 'package:dio/dio.dart';

import '../models/place_model.dart';

final dio = Dio();

Future<Place> getPlaceByIdHttp(name) async {
  var response = await dio.get("http://$ip:$port/place/$name");
  if (response.statusCode == 200) {
    return Place.fromJson(response.data);
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<List<Place>> getAllPlacesHttp(idCatering) async {
  var response = await dio.get("http://$ip:$port/place/all/$idCatering");
  if (response.statusCode == 200) {
    response.data;
    final eventList =
        (response.data as List).map((e) => Place.fromJson(e)).toList();
    return eventList;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

addPlaceHttp(Place place) async {
  await dio.post("http://$ip:$port/place/add",
      data: place.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

updatePlaceHttp(Place place) async {
  await dio.post("http://$ip:$port/place/${place.name}/update",
      data: place.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

deletePlaceHttp(name) async {
  await dio.delete("http://$ip:$port/place/$name");
}
