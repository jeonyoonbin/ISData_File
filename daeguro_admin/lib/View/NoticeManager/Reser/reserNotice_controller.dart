
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
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
    Get.put(RestApiProvider());

    raw.value = 15;
    page.value = 1;

    //getData(context);

    super.onInit();
  }

  getData(BuildContext context) async {
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_RESERVEURL+'/notice?noticeGbn=${noticeGbn.value.toString()}&dispGbn=${dispGbn.value.toString()}&frDate=${fromDate.value.toString()}&toDate=${toDate.value.toString()}&page=${page.value}&rows=${raw.value}');
        //'https://reser.daeguro.co.kr:10008/notice-admin?noticeGbn=${noticeGbn.value.toString()}&dispGbn=${dispGbn.value.toString()}&frDate=${fromDate.value.toString()}&toDate=${toDate.value.toString()}&page=${page.value}&rows=${raw.value}');

    dio.clear();
    dio.close();

    totalRowCnt = int.parse(response.data['cnt'].toString());

    //totalRowCnt = 1;

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
    //var result = await RestApiProvider.to.getNoticeDetail(noticeSeq);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_RESERVEURL+'/notice/$noticeSeq');
        //'https://reser.daeguro.co.kr:10008/notice-admin/$noticeSeq');

    dio.clear();
    dio.close();


    qDataDetail = response.data['data'][0];

    if (response.data['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
    }
  }

  // postData(Map data, BuildContext context) async {
  //   var result = await RestApiProvider.to.postNotice(data);
  //
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  // }
  //
  // putData(Map data, BuildContext context) async {
  //   var result = await RestApiProvider.to.putNotice(data);
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 수정 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  // }

  // Future<List<dynamic>> getDashboardNoticeData() async {
  //   List<dynamic> qNoticeData = [];
  //
  //   var result = await RestApiProvider.to.getDashboardNotice();
  //
  //   if (result.body['code'] == '00')
  //     qNoticeData.assignAll(result.body['data']);
  //   else
  //     return null;
  //
  //   return qNoticeData;
  // }

  updateSort(dynamic data, BuildContext context) async {
    //var result = await RestApiProvider.to.postNoticeSort(data);

    var dio = Dio();
    final response = await dio.put(ServerInfo.REST_RESERVEURL+'/notice-sort', data : data);

    dio.clear();
    dio.close();

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getNoticeSortList(String noticeGbn, BuildContext context) async {
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_RESERVEURL+'/notice-sort?noticeGbn=$noticeGbn');

    dio.clear();
    dio.close();

    //var result = await RestApiProvider.to.getNoticeSortList(noticeGbn);

    qDataSortList.assignAll(response.data['data']);

    if (response.data['code'].toString() == null ||
        response.data['code'].toString() == 'null' ||
        response.data['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }
  }
}
