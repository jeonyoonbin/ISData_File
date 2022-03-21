import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CodeController extends GetxController with SingleGetTickerProviderMixin {
  static CodeController get to => Get.find();
  BuildContext context;


  List<dynamic> qDataDetail = [];

  // int total_count = 0;
  // int totalRowCnt = 0;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxInt rows = 0.obs;
  RxInt page = 0.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    rows.value = 10;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getListData(String codeGrp, String useGbn) async {
    List<dynamic> qData = [];

    //var result = await RestApiProvider.to.getCodeList(codeGrp, useGbn);

    // dio 패키지
    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_CODE + '?codeGrp=$codeGrp&useGbn=$useGbn');

    //print('===== getData()-> '+ result.bodyString.toString());

    //total_count = int.parse(result.body['totalCount'].toString());
    //totalRowCnt = int.parse(result.body['count'].toString());

    //qData.clear();

    dio.clear();
    dio.close();

    if(result.data['code'] == '00') {
      qData.assignAll(result.data['data']);
    }
    else
      return null;

    //print('===== before qData-> ${qData.toString()}');

    return qData;
  }

  postListData(BuildContext context, String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String ETC_CODE2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8) async {

    //print('postListData: CODE_GRP:${CODE_GRP}, CODE:${CODE}, CODE_NM:${CODE_NM}, MEMO:${MEMO}, USE_TIME:${USE_TIME}, USE_GBN:${USE_GBN}, ETC_AMT1:${ETC_AMT1}, ETC_AMT2:${ETC_AMT2}, ETC_AMT3:${ETC_AMT3}, ETC_CODE_GBN1:${ETC_CODE_GBN1}, ETC_CODE_GBN3:${ETC_CODE_GBN3}, ETC_CODE_GBN4:${ETC_CODE_GBN4}, ETC_CODE_GBN5:${ETC_CODE_GBN5}, ETC_CODE_GBN6:${ETC_CODE_GBN6}, ETC_CODE_GBN7:${ETC_CODE_GBN7}');

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.postCodeListData(CODE_GRP, CODE, CODE_NM, MEMO, USE_TIME, USE_GBN, ETC_CODE2, ETC_AMT1, ETC_AMT2, ETC_AMT3, ETC_AMT4,
        ETC_CODE_GBN1, ETC_CODE_GBN3, ETC_CODE_GBN4, ETC_CODE_GBN5, ETC_CODE_GBN6, ETC_CODE_GBN7, ETC_CODE_GBN8, uCode, uName);

    // post(ServerInfo.REST_URL_RESTCODE +
    //     '?codeGrp=$CODE_GRP&
    //       code=$CODE&
    //       codeName=$CODE_NM&
    //       memo=$MEMO&
    //       amt1=$ETC_AMT1&
    //       amt2=$ETC_AMT2&
    //       amt3=$ETC_AMT3&
    //       gbn1=$ETC_CODE_GBN1&
    //       gbn3=$ETC_CODE_GBN3&
    //       value1=$ETC_CODE_GBN4&
    //       value2=$ETC_CODE_GBN5&
    //       value3=$ETC_CODE_GBN6&
    //       value4=$ETC_CODE_GBN7&
    //       useTime=$USE_TIME&
    //       useGbn=$USE_GBN&
    //       insUCode=$uCode&
    //       insName=$uName',
    //     '');
    //print('===== ret body str->'+result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body;
  }

  putListData(BuildContext context, String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String ETC_CODE2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8) async {

    //print('putListData: CODE_GRP:${CODE_GRP}, CODE:${CODE}, CODE_NM:${CODE_NM}, MEMO:${MEMO}, USE_TIME:${USE_TIME}, USE_GBN:${USE_GBN}, ETC_AMT1:${ETC_AMT1}, ETC_AMT2:${ETC_AMT2}, ETC_AMT3:${ETC_AMT3}, ETC_CODE_GBN1:${ETC_CODE_GBN1}, ETC_CODE_GBN3:${ETC_CODE_GBN3}, ETC_CODE_GBN4:${ETC_CODE_GBN4}, ETC_CODE_GBN5:${ETC_CODE_GBN5}, ETC_CODE_GBN6:${ETC_CODE_GBN6}, ETC_CODE_GBN7:${ETC_CODE_GBN7}');

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    //print('putListData uCode:${uCode}, uName:${uName}');

    var result = await RestApiProvider.to.putCodeListData(CODE_GRP, CODE, CODE_NM, MEMO, USE_TIME, USE_GBN, ETC_CODE2, ETC_AMT1, ETC_AMT2, ETC_AMT3, ETC_AMT4,
        ETC_CODE_GBN1, ETC_CODE_GBN3, ETC_CODE_GBN4, ETC_CODE_GBN5, ETC_CODE_GBN6, ETC_CODE_GBN7, ETC_CODE_GBN8, uCode, uName);
    //print('===== ret body str->'+result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body;
  }

  deleteCodeListData(BuildContext context, String CODE_GRP, String CODE) async {
    //print('CODE_GRP:${CODE_GRP}, CODE:${CODE}');

    var result = await RestApiProvider.to.deleteCodeList(CODE_GRP, CODE);
    //print('===== ret body str->'+result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getFoodSafetyData(String code) async {
    var result = await RestApiProvider.to.getFoodSafetyData(code);
    //print('===== ret body str->'+result.bodyString.toString());

    if(result.body['code'] == '00') {
      return result.body['data'];//qData.assignAll(result.body['data']);
    }
    else
      return null;
  }

  Future<dynamic> putFoodSafetyData(BuildContext context, String code, String nutrition, String allergy) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.putFoodSafetyData(code, nutrition, allergy, uCode, uName);

    if (result.body['code'] == '00') {
      return result.body['data'];
    }
    else
      return null;
  }

  // Future<List<dynamic>> getCouponCodeListData(String useGbn) async {
  //   List<dynamic> qData = [];
  //
  //   var result = await RestApiProvider.to.getCouponCodeList(useGbn);
  //
  //   // total_count = int.parse(result.body['totalCount'].toString());
  //   // totalRowCnt = int.parse(result.body['count'].toString());
  //
  //   //qData.clear();
  //
  //   if(result.body['code'] == '00') {
  //     qData.assignAll(result.body['data']);
  //   } else
  //     return null;
  //
  //   return qData;
  // }
  //
  // postCouponCodeListData(BuildContext context, String CODE, String CODE_NM, String MEMO, String USE_GBN, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3,
  //     String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7) async {
  //
  //   String uCode = GetStorage().read('logininfo')['uCode'];
  //   String uName = GetStorage().read('logininfo')['name'];
  //
  //   var result = await RestApiProvider.to.postCouponCodeListData(CODE, CODE_NM, MEMO, USE_GBN, ETC_AMT1, ETC_AMT2, ETC_AMT3, ETC_CODE_GBN4, ETC_CODE_GBN5, ETC_CODE_GBN6, ETC_CODE_GBN7, uCode, uName);
  //   //print('===== ret body str->'+result.bodyString.toString());
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  //
  //   return result.body;
  // }
  //
  // putCouponCodeListData(BuildContext context, String CODE, String CODE_NM, String MEMO, String USE_GBN, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3,
  //     String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7) async {
  //
  //   String uCode = GetStorage().read('logininfo')['uCode'];
  //   String uName = GetStorage().read('logininfo')['name'];
  //
  //   print('putListData uCode:${uCode}, uName:${uName}');
  //
  //   var result = await RestApiProvider.to.putCouponCodeListData(CODE, CODE_NM, MEMO, USE_GBN, ETC_AMT1, ETC_AMT2, ETC_AMT3, ETC_CODE_GBN4, ETC_CODE_GBN5, ETC_CODE_GBN6, ETC_CODE_GBN7, uCode, uName);
  //   //print('===== ret body str->'+result.bodyString.toString());
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  //
  //   return result.body;
  // }
  //
  // deleteCouponCodeListData(BuildContext context, String CODE) async {
  //   var result = await RestApiProvider.to.deleteCouponCodeList(CODE);
  //   //print('===== ret body str->'+result.bodyString.toString());
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  //
  //   return result.body;
  // }
}