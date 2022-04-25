
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AgentController extends GetxController with SingleGetTickerProviderMixin{
  static AgentController get to => Get.find();
  BuildContext context;
  RxString MCode = ''.obs;

  @override
  void onInit(){
    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_AGENT + '?mCode=$mCode');

    qData.clear();
    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List> getDataCCenterItems(String mCode) async {
    List qDataCCenterItems = [];

    final response = await DioClient().get(ServerInfo.REST_URL_AGENT_CODE + '?mCode=$mCode');

    qDataCCenterItems.clear();
    if (response.data['code'] == '00') {
      qDataCCenterItems.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataCCenterItems;
  }

  Future<List> getDataMCodeItems() async {
    List qDataMCodeItems = [];

    final response = await DioClient().get(ServerInfo.REST_URL_MEMBERSHIP_CODE);

    qDataMCodeItems.clear();
    if (response.data['code'] == '00') {
      qDataMCodeItems.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMCodeItems;
  }

  Future<dynamic> getDetailData(String ccCode) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_AGENT + '/$ccCode?ucode=$ucode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }
    else
      return null;
  }

  postData(dynamic data, BuildContext context) async {
    final response = await DioClient().post(ServerInfo.REST_URL_AGENT, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}