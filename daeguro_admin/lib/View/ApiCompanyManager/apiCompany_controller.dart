
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiCompanyController extends GetxController with SingleGetTickerProviderMixin{
  static ApiCompanyController get to => Get.find();
  BuildContext context;

  List qDataCCenterItems = [];
  List qDataMCodeItems = [];

  @override
  void onInit(){
    super.onInit();
  }

  Future<List<dynamic>> getData(String comType, String comGbn) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_API + '?comType=$comType&comGbn=$comGbn');

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getDetailData(String seq) async {
    final response = await DioClient().get(ServerInfo.REST_URL_API + '/' + seq);

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  postData(Map data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_API, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_API, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}