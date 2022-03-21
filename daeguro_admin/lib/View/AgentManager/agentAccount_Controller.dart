
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AgentController extends GetxController with SingleGetTickerProviderMixin{
  static AgentController get to => Get.find();
  BuildContext context;


  //dynamic qDataDetail;

  //
  //List<ResponseBodyApi> qData;

  RxString MCode = ''.obs;

  @override
  void onInit(){
    Get.put(RestApiProvider());

    //getData();

    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode) async {
    List<dynamic> qData = [];

    // var result = await RestApiProvider.to.getAgent(mCode);
    //
    // qData.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_AGENT + '?mCode=$mCode');

    dio.clear();
    dio.close();

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

    // qDataCCenterItems.clear();
    //
    // var result = await RestApiProvider.to.getAgentCode(mCode);
    //
    // qDataCCenterItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }

    //

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_AGENT_CODE + '?mCode=$mCode');

    dio.clear();
    dio.close();

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



    // var result = await RestApiProvider.to.getMembershipCode();
    //
    // qDataMCodeItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '회원사정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }
    //
    // return result.body['data'];

    //========================================================================
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_MEMBERSHIP_CODE);

    dio.clear();
    dio.close();

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

    // var result = await RestApiProvider.to.getAgentDetail(ccCode, ucode);
    //
    // qDataDetail = result.body['data'];
    // //qDataDetail.assign(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    //==================================================================================
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_AGENT + '/$ccCode?ucode=$ucode');

    //print('response-->${response.toString()}'); //response-->{"code":"00","msg":"정상","num":"1","err":"0"}
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      //print('===== before Order getData()-> '+ response.data['msg'].toString());
      return response.data['data'];
    }
    else
      return null;
  }

  postData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postAgent(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}