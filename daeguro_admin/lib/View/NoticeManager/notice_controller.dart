
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController
    with SingleGetTickerProviderMixin {
  static NoticeController get to => Get.find();
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
    var result = await RestApiProvider.to.getNotice(
        noticeGbn.value.toString(),
        dispGbn.value.toString(),
        fromDate.value.toString(),
        toDate.value.toString(),
        page.value,
        raw.value);

    totalRowCnt = int.parse(result.body['count'].toString());

    if (result.body['code'].toString() == null ||
        result.body['code'].toString() == 'null' ||
        result.body['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }

    qData.assignAll(result.body['data']);
    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getDetailData(String noticeSeq, BuildContext context) async {
    var result = await RestApiProvider.to.getNoticeDetail(noticeSeq);

    //qDataDetail.clear();


    qDataDetail = result.body['data'];

    if (result.body['code'] != '00') {
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
    var result = await RestApiProvider.to.postNoticeSort(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  getNoticeSortList(String noticeGbn, BuildContext context) async {
    var result = await RestApiProvider.to.getNoticeSortList(noticeGbn);

    qDataSortList.assignAll(result.body['data']);

    if (result.body['code'].toString() == null ||
        result.body['code'].toString() == 'null' ||
        result.body['code'].toString() == '') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return;
    }
  }
}
