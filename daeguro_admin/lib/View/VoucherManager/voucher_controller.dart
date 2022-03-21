import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/shop/shop_changepass.dart';
import 'package:daeguro_admin_app/Model/shop/shop_reviewStoreConfirm.dart';
import 'package:daeguro_admin_app/Model/voucher/VoucherTypeList.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VoucherController extends GetxController with SingleGetTickerProviderMixin {
  static VoucherController  get to => Get.find();

  int total_count = 0;
  int totalRowCnt = 0;
  RxInt rows = 0.obs;
  RxInt page = 0.obs;
  RxList<SelectOptionVO> VoucherTypeItems = <SelectOptionVO>[].obs;
  int notUse = 0;
  int use = 0;
  int clear = 0;
  int exp = 0;

  Future<List<dynamic>> getData(String testYn, String extensionYn, String voucherType, String status, String keyword) async{
    //String testYn, String extensionYn, String voucherType, String status, String keyword
    List<dynamic> qData = [];

    var dio = Dio();
    //print(ServerInfo.REST_URL_VOUCHER + '?testYn=$testYn&extensionYn=$extensionYn&voucherType=$voucherType&status=$status&page=${page.value.toString()}&rows=${rows.value.toString()}&keyword=$keyword');
    final response = await dio.get(ServerInfo.REST_URL_VOUCHER + '?testYn=$testYn&extensionYn=$extensionYn&voucherType=$voucherType&status=$status&page=${page.value.toString()}&rows=${rows.value.toString()}&keyword=$keyword');
    // final response = await dio.get(ServerInfo.REST_URL_VOUCHER + '?&page=${page.value.toString()}&rows=${rows.value.toString()}');

    dio.clear();
    dio.close();

    qData.clear();
    //print(response.data['data']);
    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['total_count'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      notUse = int.parse(response.data['notUse'].toString());
      use = int.parse(response.data['use'].toString());
      clear = int.parse(response.data['clear'].toString());
      exp = int.parse(response.data['exp'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;

  }

  Future<List> getVoucherControllerListItems(String div) async {
    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_VOUCHER_GETVOUCHERLIST + '?div=$div');

    dio.clear();
    dio.close();


    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }



}