
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiCompanyController extends GetxController with SingleGetTickerProviderMixin{
  static ApiCompanyController get to => Get.find();
  BuildContext context;

  List<dynamic> qData = [];
  dynamic qDataDetail;
  List qDataCCenterItems = [];
  List qDataMCodeItems = [];
  //List<ResponseBodyApi> qData;

  @override
  void onInit(){
    Get.put(RestApiProvider());

    //getData();

    super.onInit();
  }

  getData(String comType, String comGbn) async {
    var result = await RestApiProvider.to.getApiCompany(comType, comGbn);

    qData.assignAll(result.body['data']);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getDetailData(String seq) async {
    var result = await RestApiProvider.to.getApiCompanyDetail(seq);

    //print(result.body['data']);
    qDataDetail = result.body['data'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postApiCompany(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putApiCompany(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}