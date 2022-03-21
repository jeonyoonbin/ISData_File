import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController with SingleGetTickerProviderMixin {
  static HistoryController get to => Get.find();
  BuildContext context;

  List<dynamic> qData = [];
  List<dynamic> qDataDetail = [];
  List qDataItems = [];
  dynamic couponregist;

  int totalRowCnt = 0;
  String totalHistoryCnt = '0';
  RxInt raw = 0.obs;
  RxInt page = 0.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    raw.value = 15;
    page.value = 1;

    //getData(context);

    super.onInit();
  }

  getHistoryMileageData() async {
    List<dynamic> qHistoryData = [];

    //var result = await RestApiProvider.to.getHistoryMileage(fromDate.value.toString(), toDate.value.toString(), page.value.toString(), raw.value.toString());

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_MILEAGEHISTORY +
        '?date_begin=' +
        fromDate.value.toString() +
        '&date_end=' +
        toDate.value.toString() +
        '&page=' +
        page.value.toString() +
        '&rows=' +
        raw.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      totalHistoryCnt = response.data['totalCount'].toString();

      qHistoryData.assignAll(response.data['data']);
    } else
      return null;

    return qHistoryData;
  }
}
