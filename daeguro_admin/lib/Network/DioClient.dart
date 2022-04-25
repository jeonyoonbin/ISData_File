import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
//import 'package:get/get.dart';

class DioClient {
  //static DioClient get to => Get.find();
  //static String default_ContentType = 'text/plain';

  final Dio _dio = Dio(
      ServerInfo.REST_BASEURL ==  "http://dgpub.282.co.kr:8426" ? null : BaseOptions(
          baseUrl: 'https://admin.daeguro.co.kr',//'https://dgpub.282.co.kr:8500',//
          connectTimeout: 5000,
          receiveTimeout: 5000
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

  Future<dynamic> delete(String value) async {
    Response result = null;

    try {
      result = await _dio.delete(value);
    }
    catch (e) {
      print('Error deleting: $e');
    }

    _dio.clear();
    _dio.close();

    return result;
  }

  Future<dynamic> postRestLog(String div, String position, String msg) async {
    Response result = null;

    try {
      result = await _dio.post(ServerInfo.REST_URL_LOG_ERROR + '?div=$div&position=$position&msg=$msg');

    }
    catch (e) {
      print('Error creating: $e');
    }

    _dio.clear();
    _dio.close();

    return result;
  }
}