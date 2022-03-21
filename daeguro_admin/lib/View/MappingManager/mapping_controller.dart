import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MappingController extends GetxController with SingleGetTickerProviderMixin{
  static MappingController get to => Get.find();
  BuildContext context;

  List<dynamic> qData = [];
  dynamic qDataDetail;
  List qDataCCenterItems = [];
  List qDataMCodeItems = [];

  String checkCount;

  int totalRowCnt = 0;

  RxString raw = ''.obs;
  RxString page = ''.obs;

  //List<ResponseBodyApi> qData;

  RxString MCode = ''.obs;

  @override
  void onInit(){
    Get.put(RestApiProvider());

    raw.value = '15';
    page.value = '1';

    //getData();

    super.onInit();
  }

  getData(String useGbn, String apiType, String shopName) async {
    var result = await RestApiProvider.to.getMapping(useGbn, apiType, shopName, page.value.toString(), raw.value.toString());

    totalRowCnt = int.parse(result.body['count'].toString());

    qData.assignAll(result.body['data']);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getDetailData(String seq) async {
    var result = await RestApiProvider.to.getMappingDetail(seq);

    qDataDetail = result.body['data'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getCheckApiMap(String shop_cd) async {
    var result = await RestApiProvider.to.getCheckApiMap(shop_cd);

    checkCount = result.body['count'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상체크가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postMapping(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putMapping(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}