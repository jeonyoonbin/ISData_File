import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LogController extends GetxController with SingleGetTickerProviderMixin {
  static LogController get to => Get.find();
  BuildContext context;

  List<dynamic> qDataDetail = [];

  int total_count = 0;
  int totalRowCnt = 0;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxInt rows = 0.obs;
  RxInt page = 0.obs;

  RxString divKey = ''.obs;
  RxString keyword = ''.obs;

  RxString div = ''.obs;
  RxString userName = ''.obs;
  RxString modName = ''.obs;
  RxString type_gbn = ''.obs;

  @override
  void onInit() {
    rows.value = 30;//15;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getErrorLogData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_LOG_ERROR + '?divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    qData.clear();

    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['totalCount'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getDetailData(String seq) async {
    final response = await DioClient().get(ServerInfo.REST_URL_LOG_ERROR + '/$seq');

    if (response.data['code'] == '00') {
      qDataDetail = response.data['data'];
    }

    return null;
  }

  Future<List<dynamic>> getPrivacyLogData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_LOG_PRIVACY + '?divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    qData.clear();

    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['totalCount'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getCouponLogData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_COUPONHIST + '?div=${div.value.toString()}&type_gbn=${type_gbn.value.toString()}&divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    qData.clear();

    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['totalCount'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getRoleHistLogData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_ROLEHIST + '?div=${divKey.value.toString()}&keyword=${keyword.value.toString()}&dateBegin=${startDate.value.toString()}&dateEnd=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    qData.clear();
    if (response.data['code'] == '00') {
      // total_count = int.parse(response.data['totalCount'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }

    else
      return null;
    return qData;
  }


}