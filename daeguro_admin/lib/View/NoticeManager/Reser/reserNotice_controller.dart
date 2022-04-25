
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/Network/DioClientReserve.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReserNoticeController extends GetxController
    with SingleGetTickerProviderMixin {
  static ReserNoticeController get to => Get.find();
  BuildContext context;

  List<dynamic> qData = [];
  List<dynamic> qDataSortList = [];
  dynamic qDataDetail;
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

  getData(BuildContext context) async {
    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/notice?noticeGbn=${noticeGbn.value.toString()}&dispGbn=${dispGbn.value.toString()}&frDate=${fromDate.value.toString()}&toDate=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    totalRowCnt = int.parse(response.data['cnt'].toString());

    if (response.data['code'].toString() == null || response.data['code'].toString() == 'null' || response.data['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }

    qData.assignAll(response.data['data']);
    if (response.data['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getDetailData(String noticeSeq, BuildContext context) async {
    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/notice/$noticeSeq');

    qDataDetail = response.data['data'][0];

    if (response.data['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
    }
  }

  updateSort(dynamic data, BuildContext context) async {
    final response = await DioClientReserve().put(ServerInfo.REST_RESERVEURL+'/notice-sort', data : data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getNoticeSortList(String noticeGbn, BuildContext context) async {
    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/notice-sort?noticeGbn=$noticeGbn');

    qDataSortList.assignAll(response.data['data']);

    if (response.data['code'].toString() == null ||
        response.data['code'].toString() == 'null' ||
        response.data['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }
  }
}
