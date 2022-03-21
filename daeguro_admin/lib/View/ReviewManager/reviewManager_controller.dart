
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ReviewController extends GetxController with SingleGetTickerProviderMixin {
  static ReviewController get to => Get.find();
  BuildContext context;

  dynamic qDataDetail;

  //List<dynamic> qDataDetailMenuList = [];
  int total_count = 0;
  int totalRowCnt = 0;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    //getData();

    super.onInit();
  }

  Future<List<dynamic>> getData(String mcode, String shopCd, String tab, String divKey, String keyword, String date_begin, String date_end, String page, String rows) async {
    List<dynamic> qData = [];

    //var result = await RestApiProvider.to.getShopReview(mcode, shopCd, tab, divKey, keyword, date_begin, date_end, page, rows);

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPREVIEW +
        '?mcode=$mcode&shopCd=$shopCd&tab=$tab&divKey=$divKey&keyword=$keyword&date_begin=$date_begin&date_end=$date_end&page=$page&rows=$rows');

    dio.clear();
    dio.close();

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

    var result = await RestApiProvider.to.getDetail(seqno, ucode);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return null;
    }

    return result.body['data'];
  }

  getReportList(String seqno, BuildContext context) async {
    var result = await RestApiProvider.to.getReportList(seqno, '1', '1000');

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return null;
    }

    return result.body['data'];
  }


  putAnswer(String seqno, String answerText, String memo, String ucode, String uname, BuildContext context) async {
    var result = await RestApiProvider.to.putAnswer(seqno, answerText, memo, ucode, uname);

    // await RestApiProvider.to
    //     .postRestError('0', '/admin/ShopReview : putAnswer', '[대구로(DB) 블라인드 리뷰 답변] ' + seqno + '/' + answerText + '/' + ucode + '/' + uname + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

    if (result.body['code'] != '00') {
      await RestApiProvider.to
          .postRestError('0', '/admin/ShopReview : putAnswer', '[대구로(DB) 블라인드 리뷰 답변 실패] ' + seqno + '/' + answerText + '/' + ucode + '/' + uname + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + result.body['msg'] + ')');
      return '';
    }

    return result.body['code'];
  }

  putSetVisible(String seqno, String visible, String ucode, String uname, BuildContext context) async {
    var result = await RestApiProvider.to.putSetVisible(seqno, visible, ucode, uname);

    await RestApiProvider.to
        .postRestError('0', '/admin/ShopReview : putAnswer', '[대구로(DB) 리뷰구분 변경] ' + seqno + '/' + visible + '/' + ucode + '/' + uname + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

    if (result.body['code'] != '00') {
      await RestApiProvider.to
          .postRestError('0', '/admin/ShopReview : putAnswer', '[대구로(DB) 블라인드 리뷰구분 변경 실패] ' + seqno + '/' + visible + '/' + ucode + '/' + uname + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + result.body['msg'] + ')');
      return '';
    }

    return result.body['code'];
  }

  Future<List<dynamic>> getHistoryData(String seq, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    //var result = await RestApiProvider.to.getOptionHistory(shopCode, page, rows);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPREIVEWHIST + '/$seq?page=1&rows=1000');
    dio.clear();
    dio.close();

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    } else
      return null;

    return qDataOptionHistoryList;
  }
}
