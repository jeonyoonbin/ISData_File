import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CodeController extends GetxController with SingleGetTickerProviderMixin {
  static CodeController get to => Get.find();
  BuildContext context;

  List<dynamic> qDataDetail = [];

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxInt rows = 0.obs;
  RxInt page = 0.obs;

  @override
  void onInit() {
    rows.value = 10;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getListData(String codeGrp, String useGbn) async {
    List<dynamic> qData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_CODE + '?codeGrp=$codeGrp&useGbn=$useGbn');

    if(result.data['code'] == '00') {
      qData.assignAll(result.data['data']);
    }
    else
      return null;

    return qData;
  }

  postListData(BuildContext context, String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String ETC_CODE2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8) async {

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var response = await DioClient().post(ServerInfo.REST_URL_CODE +
        '?codeGrp=$CODE_GRP&code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&amt4=$ETC_AMT4&gbn1=$ETC_CODE_GBN1&gbn3=$ETC_CODE_GBN3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&value5=$ETC_CODE_GBN8&useTime=$USE_TIME&useGbn=$USE_GBN&etc_code2=$ETC_CODE2&insUCode=$uCode&insName=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return response.data;
  }

  putListData(BuildContext context, String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String ETC_CODE2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8) async {

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_CODE +
        '?codeGrp=$CODE_GRP&code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&amt4=$ETC_AMT4&gbn1=$ETC_CODE_GBN1&gbn3=$ETC_CODE_GBN3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&value5=$ETC_CODE_GBN8&useTime=$USE_TIME&useGbn=$USE_GBN&etc_code2=$ETC_CODE2&modUCode=$uCode&modName=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return response.data;
  }

  deleteCodeListData(BuildContext context, String codeGrp, String code) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_CODE + '?codeGrp=$codeGrp&code=$code');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getFoodSafetyData(String code) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CODE_GETFOODSAFETY + '?code=$code');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<dynamic> putFoodSafetyData(BuildContext context, String code, String nutrition, String allergy) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_CODE_PUTFOODSAFETY + '?code=$code&nutrition=$nutrition&allergy=$allergy&modUcode=$uCode&modName=$uName');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }
    else
      return null;
  }
}