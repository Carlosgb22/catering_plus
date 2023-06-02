import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiService {
  static ApiService? _instance;
  Dio dio;

  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  ApiService._internal() : dio = _createDio();

  static Dio _createDio() {
    final dio = Dio();
    final cookieJar = PersistCookieJar(storage: FileStorage('.cookies'));
    dio.interceptors.add(CookieManager(cookieJar));
    return dio;
  }
}
