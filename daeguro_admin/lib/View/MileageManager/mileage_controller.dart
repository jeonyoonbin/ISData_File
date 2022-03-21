import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
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
    Get.put(RestApiProvider());

    raw.value = 15;
    page.value = 1;

    //getData(context);

    super.onInit();
  }

  getMileageInOutList(String date_begin, String date_end, String mcode, String cust_gbn, String keyword, String page, String rows, BuildContext context) async {
    //var result = await RestApiProvider.to.getMileageInOut(date_begin, date_end, mcode, cust_gbn, keyword, page, rows);

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_MILEAGEINOUT +
        '?date_begin=$date_begin&date_end=$date_end&mcode=$mcode&cust_gbn=$cust_gbn&keyword=$keyword&page=$page&rows=$rows');

    dio.clear();
    dio.close();

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
    var result = await RestApiProvider.to.getMileageSaleInOut(date_begin, date_end, mcode, sale_gbn, cust_gbn);

    //totalRowCnt = int.parse(result.body['totalCount'].toString());

    if (result.body['code'].toString() == null || result.body['code'].toString() == 'null' || result.body['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body['data'];
  }
}
