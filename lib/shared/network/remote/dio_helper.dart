

import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(
      path,
      queryParameters: query,
    );
  }
  static void printResponse(Response response) {
    print('Response data: ${response.data}');
    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response request: ${response.requestOptions}');
  }
}
