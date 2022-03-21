import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
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
    Get.put(RestApiProvider());

    raw.value = '15';
    page.value = '1';

    //getData();

    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode, String custCode, String shopCd) async {
    List<dynamic> qData = [];

    if (custCode == null) custCode = '';

    if (shopCd == null) shopCd = '';

    // var result = await RestApiProvider.to.getOrder(mCode, startdate.value.toString(), enddate.value.toString(), state.value.toString(), tel.value.toString(), name.value.toString(), custCode, shopCd,
    //     divKey.value.toString(), page.value.toString(), raw.value.toString());
    //
    // total_count = int.parse(result.body['total_count'].toString());
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // //print('===== before Order getData()-> '+ result.body['data'].toString());
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;
    //getOrder(String mCode, String startdate, String enddate, String state, String telNo, String keyword, String custCode, String shopCd, String divKey, String page, String rows)
    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_ORDER + '?mCode=$mCode&dateBegin=${enddate.value.toString()}&dateEnd=${enddate.value.toString()}&state=${state.value.toString()}&divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&cust_code=$custCode&shop_cd=$shopCd&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

    // print(divKey);
    qData.clear();
    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['total_count'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getOrderList(String mCode, String custCode, String shopCd) async {
    List<dynamic> qData = [];

    if (custCode == null) custCode = '';

    if (shopCd == null) shopCd = '';

    // print('mCode: ${mCode}, startdate: ${startdate.value.toString()}, enddate: ${enddate.value.toString()}, state: ${state.value.toString()},'
    //     ' tel: ${tel.value.toString()}, name: ${name.value.toString()}, custCode: ${custCode}, divKey: ${divKey.value.toString()}, page: ${page.value.toString()}, raw: ${raw.value.toString()}');

    var result = await RestApiProvider.to.getOrderList(mCode, startdate.value.toString(), enddate.value.toString(), state.value.toString(), tel.value.toString(), name.value.toString(), custCode,
        shopCd, divKey.value.toString(), page.value.toString(), raw.value.toString());

    total_count = int.parse(result.body['total_count'].toString());
    totalRowCnt = int.parse(result.body['count'].toString());

    //print('===== before Order getData()-> '+ result.body['data'].toString());

    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    if (result.body['code'] == '00')
      qData.assignAll(result.body['data']);
    else
      return null;

    return qData;
  }

  getDetailData(String orderSeq, BuildContext context) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    var result = await RestApiProvider.to.getOrderDetail(orderSeq, ucode);

    qDataDetail = result.body['data'];
    qDataDetailMenuInfo = result.body['data']['menuDesc'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  // postData(Map data, BuildContext context, String mCode) async {
  //   var result = await RestApiProvider.to.postOrder(data);
  //
  //   //getData(context, mCode);
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  // }

  putData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putOrder(data);

    await RestApiProvider.to
        .postRestError('0', '/admin/Order : putData', '[대구로(DB) 상태변경] ' + data.toString() + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

    if (result.body['code'] != '00') {
      await RestApiProvider.to
          .postRestError('0', '/admin/Order : putData', '[대구로(DB) 상태변경 실패] ' + data.toString() + ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

      ISAlert(context, '대구로(DB) 상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.\n(' + result.body['msg'] + ')');
      return '';
    }

    return result.body['code'];
  }

  postPayApiCancel(Map header, Map body, Map data, var posheader, var posbody, BuildContext context) async {
    var result = await RestApiProvider.to.postPayApiCancel(body);

    if (result.body == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    } else {
      if (result.body['Result'][0]['result_info'][0]['code'] != '1000') {
        await RestApiProvider.to.postRestError('0', '/Order/postPayBasicCancel : postPayBasicCancel', '[카드 취소 실패(KCP)]' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      } else {
        var result2 = await RestApiProvider.to.putOrderSetCardApprovalGbn(body['order_no']);

        if (result2.body['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                '[POS 상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await http.post(Uri.parse('https://pos.daeguro.co.kr:15409/orderApi/POSOrder/B2B_OrderStatus_Change_Manage'), headers: posheader, body: posbody.toString()).then((http.Response response) async {
              if (response.statusCode == 200) {
                var decodeBody = jsonDecode(response.body);

                if (decodeBody['code'] != 0) {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                } else {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 성공] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                }
              } else {
                var decodeBody = jsonDecode(response.body);

                await RestApiProvider.to
                    .postRestError('0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
              }
            });
          }
        } else {
          await RestApiProvider.to.postRestError('0', '/Order/setCardApprovalGbn : postPayBasicCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  postPayBasicCancel(Map header, Map body, Map data, var posheader, var posbody, BuildContext context) async {
    var result = await RestApiProvider.to.postPayBasicCancel(body);

    if (result.body == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    } else {
      if (result.body['Result'][0]['result_info'][0]['code'] != '1000') {
        await RestApiProvider.to.postRestError('0', '/Order/postPayBasicCancel : postPayBasicCancel', '[카드 취소 실패(KCP)]' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      } else {
        var result2 = await RestApiProvider.to.putOrderSetCardApprovalGbn(body['order_no']);

        if (result2.body['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                '[POS 상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await http.post(Uri.parse('https://pos.daeguro.co.kr:15409/orderApi/POSOrder/B2B_OrderStatus_Change_Manage'), headers: posheader, body: posbody.toString()).then((http.Response response) async {
              if (response.statusCode == 200) {
                var decodeBody = jsonDecode(response.body);

                if (decodeBody['code'] != 0) {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                } else {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 성공] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                }
              } else {
                var decodeBody = jsonDecode(response.body);

                await RestApiProvider.to
                    .postRestError('0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
              }
            });
          }
        } else {
          await RestApiProvider.to.postRestError('0', '/Order/setCardApprovalGbn : postPayBasicCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  postPaySmartCancel(Map header, Map body, Map data, var posheader, var posbody, BuildContext context) async {
    var result = await RestApiProvider.to.postPaySmartCancel(body);

    if (result.body == null) {
      ISAlert(context, '카드 결제 정보가 없습니다. \n관리자에게 문의 바랍니다.');
    } else {
      if (result.body['Result'][0]['result_info'][0]['code'] != '1000') {
        await RestApiProvider.to.postRestError('0', '/Order/postPaySmartCancel : postPaySmartCancel', '[카드 취소 실패(KCP)]  ' + posbody.toString() + ' || ' + body.toString());
        ISAlert(context, '정상적으로 카드 결제가 취소 되지 않았습니다. \n관리자에게 문의 바랍니다.');
      }
      else {
        var result2 = await RestApiProvider.to.putOrderSetCardApprovalGbn(body['order_no']);

        print('postPaySmartCancel response:${result2.bodyString.toString()}');

        if (result2.body['code'] == '00') {
          var result3 = await OrderController.to.putData(data, context);

          if (result3 == '00') {
            // POS REQUEST 정보
            await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                '[POS 상태변경 요청] ' + posbody.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

            //pos 상태정보 업데이트
            await http.post(Uri.parse('https://pos.daeguro.co.kr:15409/orderApi/POSOrder/B2B_OrderStatus_Change_Manage'), headers: posheader, body: posbody.toString()).then((http.Response response) async {
              if (response.statusCode == 200) {
                var decodeBody = jsonDecode(response.body);

                if (decodeBody['code'] != 0) {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                } else {
                  await RestApiProvider.to
                      .postRestError('0', '/admin/Order : putData', '[POS 상태변경 성공] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                }
              } else {
                var decodeBody = jsonDecode(response.body);
                await RestApiProvider.to
                    .postRestError('0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + posbody.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
              }
            });
          }
        }
        else {
          await RestApiProvider.to.postRestError('0', '/Order/setCardApprovalGbn : postPaySmartCancel', body['order_no'] + ' : ApprovalGbn "N" 으로 변경 실패 하였습니다.');
          ISAlert(context, '상태 변경에 실패 했습니다.(ApprovalGbn ERR) \n관리자에게 문의 바랍니다.');
        }
      }
    }
  }

  Future<dynamic> getOrderCancelReasonsData(String shopCd, String startDate, String endDate) async {
    dynamic qData;

    var result = await RestApiProvider.to.getOrderCancelReasons(shopCd, startDate, endDate);

    if (result.body['code'] == '00') {
      qData = result.body['data'];
      //mData.value = DashBoardModel.fromJson(qData);
    } else
      return null;

    return qData;
  }

  Future<dynamic> getOrderCompleteToCancel(String mCode, String dateBegin, String dateEnd) async {
    dynamic qData;

    var result = await RestApiProvider.to.getOrderCompleteToCancel(mCode, dateBegin, dateEnd, page.value.toString(), raw.value.toString());

    total_count = int.parse(result.body['total_count'].toString());
    totalRowCnt = int.parse(result.body['count'].toString());

    if (result.body['code'] == '00') {
      qData = result.body['data'];
      //mData.value = DashBoardModel.fromJson(qData);
    } else
      return null;

    return qData;
  }

  Future<dynamic> getOrderCardApprovalGbn(String order_no) async {
    String card_approval_gbn;

    var result = await RestApiProvider.to.getOrderCardApprovalGbn(order_no);

    if (result.body['code'] == '00') {
      card_approval_gbn = result.body['data']['CARD_APPROVAL_GBN'];
      //mData.value = DashBoardModel.fromJson(qData);
    } else
      return null;

    return card_approval_gbn;
  }
}