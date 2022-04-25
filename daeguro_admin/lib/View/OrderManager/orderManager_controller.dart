import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/Network/DioClientPay.dart';
import 'package:daeguro_admin_app/Network/DioClientPos.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController with SingleGetTickerProviderMixin{
  static OrderController get to => Get.find();
  BuildContext context;

  dynamic qDataDetail;
  dynamic qDataDetailMenuInfo;

  //List<dynamic> qDataDetailMenuList = [];
  int total_count = 0;
  int totalRowCnt = 0;

  RxString startdate = ''.obs;
  RxString enddate = ''.obs;
  RxString state = ''.obs;
  RxString divKey = ''.obs;
  RxString tel = ''.obs;
  RxString name = ''.obs;
  RxString raw = ''.obs;
  RxString page = ''.obs;

  @override
  void onInit(){
    //

    raw.value = '15';
    page.value = '1';

    //getData();

    super.onInit();
  }

  Future<List<dynamic>> getOrderList(String mCode, String custCode, String shopCd) async {
    List<dynamic> qData = [];

    if (custCode == null) custCode = '';

    if (shopCd == null) shopCd = '';

    final response = await DioClient().get(ServerInfo.REST_URL_ORDERLIST + '?mCode=$mCode&dateBegin=${startdate.value.toString()}&dateEnd=${enddate.value.toString()}&state=${state.value.toString()}&divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&cust_code=$custCode&shop_cd=$shopCd&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['total_count'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  getDetailData(String orderSeq) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_ORDER + '/$orderSeq?ucode=$ucode');

    if (response.data['code'] == '00') {
      qDataDetail = response.data['data'];
      qDataDetailMenuInfo = response.data['data']['menuDesc'];
    }
    else
      return null;

  }

  putData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_ORDER, data: data);//dio.put(ServerInfo.REST_URL_ORDER, data: data);

    await DioClient().postRestLog('0', '/Order/putData', '[대구로(DB) 상태변경] ' + data.toString() + ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

    if (response.data['code'] != '00') {
      await DioClient().postRestLog('0', '/Order/putData', '[대구로(DB) 상태변경 실패] ' + data.toString() + ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + response.data['msg'] + ')');
      return '';
    }

    return response.data['code'];
  }

  postPayApiCancel(Map body, Map data, var posbody, BuildContext context) async {
    var result = await DioClientPay().postPayCancel(ServerInfo.PAY_API_CANCEL, body);//RestApiProvider.to.postPayApiCancel(body);

    if (result.data == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    }
    else {
      if (result.data['Result'][0]['result_info'][0]['code'] != '1000') {
        await DioClient().postRestLog('0', '/Order/postPayApiCancel : postPayApiCancel', '[카드 취소 실패(KCP)]' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      }
      else {
        final result2 = await DioClient().put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);//dio.put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);

        if (result2.data['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await DioClient().postRestLog('0', '/Order/postPayApiCancel', '[POS 오더상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await setPosOrderChange(posbody.toString(), '/Order/postPayApiCancel');
          }
        }
        else {
          await DioClient().postRestLog('0', '/Order/setCardApprovalGbn : postPayBasicCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  postPayBasicCancel(Map body, Map data, var posbody, BuildContext context) async {
    var result = await DioClientPay().postPayCancel(ServerInfo.PAY_BASIC_CANCEL, body);//RestApiProvider.to.postPayBasicCancel(body);

    if (result.data == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    }
    else {
      if (result.data['Result'][0]['result_info'][0]['code'] != '1000') {
        await DioClient().postRestLog('0', '/Order/postPayBasicCancel : postPayBasicCancel', '[카드 취소 실패(KCP)]' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      }
      else {
        final result2 = await DioClient().put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);//dio.put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);

        if (result2.data['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await DioClient().postRestLog('0', '/Order/postPayBasicCancel', '[POS 오더상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await setPosOrderChange(posbody.toString(), '/Order/postPayBasicCancel');
          }
        }
        else {
          await DioClient().postRestLog('0', '/Order/setCardApprovalGbn : postPayBasicCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  postPaySmartCancel(Map body, Map data, var posbody, BuildContext context) async {
    var result = await DioClientPay().postPayCancel(ServerInfo.PAY_SMART_CANCEL, body);//RestApiProvider.to.postPaySmartCancel(body);

    if (result.data == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    }
    else {
      if (result.data['Result'][0]['result_info'][0]['code'] != '1000') {
        await DioClient().postRestLog('0', '/Order/postPaySmartCancel : postPaySmartCancel', '[카드 취소 실패(KCP)]  ' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      }
      else {
        final result2 = await DioClient().put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);//dio.put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + body['order_no']);

        if (result2.data['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await DioClient().postRestLog('0', '/Order/postPaySmartCancel', '[POS 오더상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await setPosOrderChange(posbody.toString(), '/Order/postPaySmartCancel');
          }
        }
        else {
          await DioClient().postRestLog('0', '/Order/setCardApprovalGbn : postPaySmartCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  Future<dynamic> setPosOrderChange(String data, String path) async {
    await DioClientPos().post(ServerInfo.REST_URL_POSORDER_CHANGE, data).then((response) async {
      if (response.statusCode == 200) {
        //var decodeBody = jsonDecode(response.data.toString());
        if (response.data['code'] != 0) {
          await DioClient().postRestLog('0', path, '[POS 오더상태변경 실패] ' + data.toString() + ' || return : [' + response.statusCode.toString() + ']' + response.data.toString());
        }
        else {
          await DioClient().postRestLog('0', path, '[POS 오더상태변경 성공] ' + data.toString() + ' || return : [' + response.statusCode.toString() + ']' + response.data.toString());
        }
      } else {
        //var decodeBody = jsonDecode(response.data['data']);
        await DioClient().postRestLog('0', path, '[POS 오더상태변경 통신 실패] ' + data.toString() + ' || return : [' + response.statusCode.toString() + ']' + response.data.toString());
      }
    });
  }

  Future<dynamic> getOrderCancelReasonsData(String shopCd, String startDate, String endDate) async {
    dynamic qData;

    final response = await DioClient().get(ServerInfo.REST_URL_ORDER_CANCELREASONS + '/' + shopCd + '?date_begin=$startDate&date_end=$endDate');

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getOrderCompleteToCancel(String mCode, String dateBegin, String dateEnd) async {
    dynamic qData;

    final response = await DioClient().get(ServerInfo.REST_URL_ORDER_COMPLETETOCANCEL + '?mCode=$mCode&dateBegin=$dateBegin&dateEnd=$dateEnd&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['total_count'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getOrderCardApprovalGbn(String order_no) async {
    String card_approval_gbn;

    final response = await DioClient().get(ServerInfo.REST_URL_ORDER_GETCARDAPPROVALGBN + '/$order_no');

    if (response.data['code'] == '00') {
      card_approval_gbn = response.data['data']['CARD_APPROVAL_GBN'];
    }
    else
      return null;

    return card_approval_gbn;
  }
}