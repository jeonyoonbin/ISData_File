
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ReviewController extends GetxController with SingleGetTickerProviderMixin {
  static ReviewController get to => Get.find();
  BuildContext context;

  dynamic qDataDetail;

  int total_count = 0;
  int totalRowCnt = 0;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getData(String mcode, String shopCd, String tab, String divKey, String keyword, String date_begin, String date_end, String page, String rows) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPREVIEW +
        '?mcode=$mcode&shopCd=$shopCd&tab=$tab&divKey=$divKey&keyword=$keyword&date_begin=$date_begin&date_end=$date_end&page=$page&rows=$rows');

    total_count = int.parse(response.data['total_count'].toString());
    totalRowCnt = int.parse(response.data['count'].toString());

    if (response.data['code'] == '00')
      qData.assignAll(response.data['data']);
    else
      return null;

    return qData;
  }

  getDetail(String seqno, BuildContext context) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPREVIEW + '/$seqno?ucode=$ucode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  getReportList(String seqno, BuildContext context) async {
    final response = await DioClient().get(ServerInfo.REST_URL_REPORTLIST + '/$seqno?page=1&rows=1000');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  putAnswer(String seqno, String answerText, String memo, String ucode, String uname, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPREVIEW + '/$seqno?answerText=$answerText&memo=$memo&ucode=$ucode&uname=$uname');

    if (response.data['code'] != '00') {
      await DioClient().postRestLog('0', '/ShopReview', '[대구로(DB) 블라인드 리뷰 답변 실패] ' + seqno + '/' + answerText + '/' + ucode + '/' + uname + ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + response.data['msg'] + ')');
      return '';
    }

    return response.data['code'];
  }

  putSetVisible(String seqno, String visible, String ucode, String uname, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SETVISIBLE + '/$seqno?visible=$visible&ucode=$ucode&uname=$uname');

    await DioClient().postRestLog('0', '/ShopReview/setVisible', '[대구로(DB) 리뷰구분 변경] ' + seqno + '/' + visible + '/' + ucode + '/' + uname + ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

    if (response.data['code'] != '00') {
      await DioClient().postRestLog('0', '/ShopReview/setVisible', '[대구로(DB) 블라인드 리뷰구분 변경 실패] ' + seqno + '/' + visible + '/' + ucode + '/' + uname + ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + response.data['msg'] + ')');
      return '';
    }

    return response.data['code'];
  }

  Future<List<dynamic>> getHistoryData(String seq, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPREIVEWHIST + '/$seq?page=1&rows=1000');

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    } else
      return null;

    return qDataOptionHistoryList;
  }
}
