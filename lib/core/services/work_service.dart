import 'package:catering_plus/core/config/config.dart';
import 'package:dio/dio.dart';

import '../models/work_model.dart';

final dio = Dio();

Future<Work> getWorkByIdHttp(dni, id) async {
  var response = await dio.get("http://$ip:$port/work/$dni/$id");
  if (response.statusCode == 200) {
    return Work.fromJson(response.data);
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

Future<List<Work>> getAllWorksHttp(dni) async {
  var response = await dio.get("http://$ip:$port/work/all/$dni");
  if (response.statusCode == 200) {
    response.data;
    final workList =
        (response.data as List).map((e) => Work.fromJson(e)).toList();
    return workList;
  } else {
    throw Exception('Error al obtener el JSON');
  }
}

addWorkHttp(Work work) async {
  await dio.post("http://$ip:$port/work/add",
      data: work.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

updateWorkHttp(Work work) async {
  await dio.post("http://$ip:$port/work/${work.dni}/${work.eventId}/update",
      data: work.toJson(),
      options: Options(headers: {"Content-type": "application/json"}));
}

deleteWorkHttp(dni, id) async {
  await dio.delete("http://$ip:$port/work/$dni/$id");
}
