import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LogController extends GetxController with SingleGetTickerProviderMixin {
  static LogController get to => Get.find();
  BuildContext context;

  //List<dynamic> qData = [];
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
  RxString uname = ''.obs;
  RxString type_gbn = ''.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    rows.value = 30;//15;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getErrorLogData() async {
    List<dynamic> qData = [];
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_LOG_ERROR + '?divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    dio.clear();
    dio.close();

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

  getDetailData(String seq) async {
    var result = await RestApiProvider.to.getErrorLogDetail(seq);

    qDataDetail = result.body['data'];
    //print('${qDataDetail}하히후헤호');

    if(result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
    }
  }

  Future<List<dynamic>> getPrivacyLogData() async {
    List<dynamic> qData = [];
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_LOG_PRIVACY + '?divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    dio.clear();
    dio.close();

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
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_COUPONHIST + '?div=${div.value.toString()}&type_gbn=${type_gbn.value.toString()}&divKey=${divKey.value.toString()}&keyword=${keyword.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    dio.clear();
    dio.close();

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
    var dio = Dio();
    //print(ServerInfo.REST_URL_ROLEHIST + '?&uname=${uname.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');
    final response = await dio.get(ServerInfo.REST_URL_ROLEHIST + '?&uname=${uname.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    dio.clear();
    dio.close();

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