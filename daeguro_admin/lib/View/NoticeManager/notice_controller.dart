
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController
    with SingleGetTickerProviderMixin {
  static NoticeController get to => Get.find();
  BuildContext context;

  List qDataItems = [];

  int totalRowCnt = 0;

  RxString noticeGbn = ''.obs;
  RxString dispGbn = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;
  RxInt raw = 0.obs;
  RxInt page = 0.obs;

  @override
  void onInit() {
    raw.value = 15;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getData() async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_NOTICE + '?noticeGbn=${noticeGbn.value.toString()}&dispGbn=${dispGbn.value.toString()}&fromDate=${fromDate.value.toString()}&toDate=${toDate.value.toString()}&page=${page.value}&rows=${raw.value}');

    if (response.data['code'].toString() == null || response.data['code'].toString() == 'null' || response.data['code'].toString() == '') {
      return null;
    }

    if (response.data['code'] == '00') {
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;

  }

  Future<dynamic> getDetailData(String noticeSeq) async {
    final response = await DioClient().get(ServerInfo.REST_URL_NOTICE + '/$noticeSeq');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  updateSort(dynamic data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_NOTICE_SORT, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getNoticeSortList(String noticeGbn) async {
    List<dynamic> qDataMenuGroup = [];

    final response = await DioClient().get(ServerInfo.REST_URL_NOTICE + '/getNoticeSortList?noticeGbn=$noticeGbn');

    if (response.data['code'].toString() == null || response.data['code'].toString() == 'null' || response.data['code'].toString() == '') {
      return null;
    }

    if (response.data['code'] == '00') {
      qDataMenuGroup.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuGroup;
  }
}
