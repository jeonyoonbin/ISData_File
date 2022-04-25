import 'package:dio/dio.dart';

class DioClientPos {
  //static DioClient get to => Get.find();
  //static String default_ContentType = 'text/plain';

  static Map<String, dynamic> Header_Pos = {
    "Access-Control-Allow-Origin": "*",
    // Required for CORS support to work
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Methods": "*",
    "Content-Type": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im9yZGVyX2NvbXAiLCJhcHBfdHlwZSI6Im9yZGVyIiwiYXBwX25hbWUiOiJkYWd1cm9hcHAiLCJuYmYiOjE2NDExODcwMDAsImV4cCI6MTY3NTIwNjAwMCwiaWF0IjoxNjQxMTg3MDAwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDoxNTQwOSIsImF1ZCI6Ikluc3VuZ1BPUyJ9.hVaYELqN7i9IQ3o00LRcF--sCv6up7slUq1i94WDw78",
    //"Accept": "application/json",
  };

  final Dio _dio = Dio(
      BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 5000,
          headers: Header_Pos
      )
  );

  Future<dynamic> post(String value, dynamic data) async {
    Response result = null;

    try {
      result = await _dio.post(value, data: data);
    }
    catch (e) {
      print('Error creating: $e');
    }

    _dio.clear();
    _dio.close();

    return result;
  }
}