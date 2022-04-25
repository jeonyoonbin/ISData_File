
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

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
    raw.value = 15;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_CUSTOMER + '?divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&custCode=${custCode.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

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

    final response = await DioClient().get(ServerInfo.REST_URL_CUSTOMERINFO + '/$custCode?ucode=$ucode');

    if (response.data['code'] == '00') {

      return response.data['data'];
    }
    else
      return null;
  }

  Future<List<dynamic>> getMileageData(String custCode) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_CUSTOMERMILEAGE + '/$custCode');

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

    final response = await DioClient().get(ServerInfo.REST_URL_CUSTOMERCOUPON + '/$custCode?status=$status');

    qData.clear();
    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  putJoinInfo(String cust_code, String cust_id, String memo, String mod_ucode, String mod_name, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_CUSTOMERINFO + '/$cust_code?cust_id=$cust_id&memo=$memo&mod_ucode=$mod_ucode&mod_name=$mod_name');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 수정 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteCustomerRetire(String cust_code, String retire_memo, BuildContext context) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_CUSTOMERRETIRE + '/$cust_code?retire_memo=$retire_memo');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}
