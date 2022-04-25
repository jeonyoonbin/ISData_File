import 'package:dio/dio.dart';

class DioClientPay {
  //static DioClient get to => Get.find();
  //static String default_ContentType = 'text/plain';

  static Map<String, dynamic> Header_PayCancel = {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
    "Authorization": "QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
    "Method": "DELETE",
    "Content-Type": "application/json",
  };

  final Dio _dio = Dio(
      BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 5000,
          headers: Header_PayCancel
      )
  );

  Future<dynamic> postPayCancel(String value, dynamic data) async {
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