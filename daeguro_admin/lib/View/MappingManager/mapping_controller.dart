import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MappingController extends GetxController with SingleGetTickerProviderMixin{
  static MappingController get to => Get.find();
  BuildContext context;

  List qDataCCenterItems = [];
  List qDataMCodeItems = [];

  int totalRowCnt = 0;

  RxString raw = ''.obs;
  RxString page = ''.obs;
  RxString MCode = ''.obs;

  @override
  void onInit(){
    raw.value = '15';
    page.value = '1';

    super.onInit();
  }

  Future<List<dynamic>> getData(String useGbn, String apiType, String shopName) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_MAPPING + '?usgGbn=$useGbn&apiType=$apiType&shopName=$shopName&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (response.data['code'] == '00') {
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getDetailData(String seq) async {
    final response = await DioClient().get(ServerInfo.REST_URL_MAPPING + '/' + seq);

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<dynamic> getCheckApiMap(String shop_cd) async {
    final response = await DioClient().get(ServerInfo.REST_URL_MAPPING_CHECK + '/' + shop_cd);

    if (response.data['code'] == '00') {
      return response.data['count'];
    }

    return null;
  }

  postData(Map data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_MAPPING, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_MAPPING, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}