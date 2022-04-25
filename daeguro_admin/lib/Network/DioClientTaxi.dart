import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
//import 'package:get/get.dart';

class DioClientTaxi {
  //static DioClient get to => Get.find();
  //static String default_ContentType = 'text/plain';

  static Map<String, dynamic> Header_Reserve = {
    //'Authorization' : 'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTQwIiwiSWQiOiJ0ZXN0Y3VzdDAxQG5hdmVyLmNvbSIsIklkR2JuIjoiQSIsImp0aSI6Ijg0NTU2YTJjLTA5NTgtNGM0MS04YzdmLTk5NzZhMTZjNTU3OSIsIm5iZiI6MTYyMTkzNzc0OSwiZXhwIjoxNjIxOTM3OTI5LCJpYXQiOjE2MjE5Mzc3NDl9.LXMrAEn0nFeA12-ALUPouwVHJ2DxXN_eRUCnFxSjGsU',
    'Content-Type' : 'application/json'
  };

  final Dio _dio = Dio(
      BaseOptions(
          baseUrl: ServerInfo.REST_RESERVEURL,
          connectTimeout: 5000,
          receiveTimeout: 5000,
          headers: Header_Reserve
      )
  );

  Future<dynamic> get(String value) async {
    Response result = null;
    try{
      result = await _dio.get(value);
    } on DioError catch (e){
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      }
      else {
        print('Error sending request!');
        print(e.message);
      }
    }

    _dio.clear();
    _dio.close();

    return result;
  }

  Future<dynamic> post(String value, {dynamic data}) async {
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

  Future<dynamic> put(String value, {dynamic data}) async {
    Response result = null;

    try {
      result = await _dio.put(value, data: data);
    }
    catch (e) {
      print('Error updating: $e');
    }

    _dio.clear();
    _dio.close();

    return result;
  }

  Future<dynamic> deleteImage(String value, String ccCode, String shopCd, String seq) async {
    Response result = null;

    try {
      result = await _dio.delete(value, data: {"ccCode": ccCode , "shopCode": shopCd , "seq": seq});
    } catch (e) {
      print('Error deleting: $e');
    }

    _dio.clear();
    _dio.close();

    return result;
  }
}