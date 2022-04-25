import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MileageController extends GetxController with SingleGetTickerProviderMixin {
  static MileageController get to => Get.find();
  BuildContext context;

  List<dynamic> sumData = [];
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

  getMileageInOutList(String date_begin, String date_end, String mcode, String cust_gbn, String keyword, String page, String rows, BuildContext context) async {
    final response = await DioClient().get(ServerInfo.REST_URL_MILEAGEINOUT +
        '?date_begin=$date_begin&date_end=$date_end&mcode=$mcode&cust_gbn=$cust_gbn&keyword=$keyword&page=$page&rows=$rows');

    totalRowCnt = int.parse(response.data['totalCount'].toString());

    if (response.data['code'].toString() == null || response.data['code'].toString() == 'null' || response.data['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }

    if (response.data['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    sumData = response.data['sumData'];

    return response.data['data'];
  }

  getMileageSaleInOutList(String date_begin, String date_end, String mcode, String sale_gbn, String cust_gbn, BuildContext context) async {
    final response = await DioClient().get(ServerInfo.REST_URL_MILEAGESALEINOUT + '?date_begin=$date_begin&date_end=$date_end&mcode=$mcode&sale_gbn=$sale_gbn&cust_gbn=$cust_gbn');

    if (response.data['code'].toString() == null || response.data['code'].toString() == 'null' || response.data['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }

    if (response.data['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return response.data['data'];
  }
}
