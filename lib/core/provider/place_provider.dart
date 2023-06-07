import 'package:catering_plus/core/models/place_model.dart';
import 'package:latlong2/latlong.dart';

import '../services/place_service.dart';

Future<Place> getPlaceById(String name) {
  return getPlaceByIdHttp(name);
}

Future<List<Place>> getAllPlaces() {
  return getAllPlacesHttp();
}

deletePlace(String name) {
  deletePlaceHttp(name);
}

updatePlace(Place place) {
  updatePlaceHttp(place);
}

addPlace(Place place) {
  addPlaceHttp(place);
}

getPlaceMap(String address) {
  final coords = address.split(',');
  final lat = coords[0];
  final lon = coords[1];
  LatLng eventLocation = LatLng(double.parse(lat), double.parse(lon));
  return eventLocation;
}
