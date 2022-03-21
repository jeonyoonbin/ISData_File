
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomerController extends GetxController with SingleGetTickerProviderMixin {
  static CustomerController get to => Get.find();

  int totalRowCnt = 0;
  int totalMileage = 0;
  RxInt raw = 0.obs;
  RxInt page = 0.obs;
  RxString name = ''.obs;
  RxString custCode = ''.obs;
  RxString divKey = ''.obs;

  String Mainmileage = '0';
  String Maincoupon = '0';
  String Maincustomer = '0';

  @override
  void onInit() {
    Get.put(RestApiProvider());

    raw.value = 15;
    page.value = 1;

    //getData(context);

    super.onInit();
  }

  Future<List<dynamic>> getData() async {
    List<dynamic> qData = [];

    // var result = await RestApiProvider.to.getCustomer(divKey.value.toString(), name.value.toString(), custCode.value.toString(), page.value.toString(), raw.value.toString());
    //
    // totalRowCnt = int.parse(result.body['totalCount'].toString());
    //
    // Mainmileage = result.body['mileage'].toString();
    // Maincoupon = result.body['coupon'].toString();
    // Maincustomer = result.body['customer'].toString();
    //
    // if (result.body['code'] == '00') {
    //   qData.assignAll(result.body['data']);
    // }
    // else
    //   return null;
    //
    // return qData;

    //=========================================================
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_CUSTOMER + '?divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&custCode=${custCode.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

    // print(divKey);
    qData.clear();
    if (response.data['code'] == '00') {
      totalRowCnt = int.parse(response.data['totalCount'].toString());

      Mainmileage = response.data['mileage'].toString();
      Maincoupon = response.data['coupon'].toString();
      Maincustomer = response.data['customer'].toString();

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getInfoData(String custCode) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    //var result = await RestApiProvider.to.getCustomerInfo(custCode, ucode);
    //
    // if (result.body['code'] == '00')
    //   return result.body['data'];//qData.assignAll(result.body['data']);
    // else
    //   return null;

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_CUSTOMERINFO + '/$custCode?ucode=$ucode');

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {

      return response.data['data'];
    }
    else
      return null;
  }

  Future<List<dynamic>> getMileageData(String custCode) async {
    List<dynamic> qData = [];

    // var result = await RestApiProvider.to.getCustomerMileage(custCode);
    //
    // if (result.body['code'] == '00') {
    //   totalMileage = int.parse(result.body['totalMileage'].toString());
    //
    //   //print('===== getMileageData()-> '+ result.bodyString.toString());
    //
    //   qData.assignAll(result.body['data']);
    // }
    // else
    //   return null;
    //
    // return qData;

    //
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_CUSTOMERMILEAGE + '/$custCode');

    dio.clear();
    dio.close();

    qData.clear();
    if (response.data['code'] == '00') {
      totalMileage = int.parse(response.data['totalMileage'].toString());
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getCouponData(String custCode, String status) async {
    List<dynamic> qData = [];

    // var result = await RestApiProvider.to.getCustomerCoupon(custCode, status);
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;

    //=============================================================================
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_CUSTOMERCOUPON + '/$custCode?status=$status');

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

  putJoinInfo(String cust_code, String cust_id, String memo, String mod_ucode, String mod_name, BuildContext context) async {
    var result = await RestApiProvider.to.putCustomerJoinInfo(cust_code, cust_id, memo, mod_ucode, mod_name);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 수정 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteCustomerRetire(String cust_code, String retire_memo, BuildContext context) async {
    var result = await RestApiProvider.to.deleteCustomerRetire(cust_code, retire_memo);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
    //getSectorData(shopCode);
  }
}
