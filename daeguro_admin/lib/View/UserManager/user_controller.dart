import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController with SingleGetTickerProviderMixin {
  static UserController get to => Get.find();

  List qDataItems = [];
  dynamic couponregist;

  int total_count = 0;
  int totalRowCnt = 0;

  RxString level = '1'.obs;
  RxString working = '1'.obs;
  RxString id_name = ''.obs;
  RxString memo = ''.obs;
  RxString raw = '1'.obs;
  RxString page = '1'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getData(BuildContext context, String mCode) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_USER + '?mCode=$mCode&level=${level.value.toString()}&working=${working.value.toString()}&id_name=${id_name.value.toString()}&memo=${memo.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

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

  Future<dynamic> getDetailData(String uCode) async {
    String rUcode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_USER + '/$uCode?rUcode=$rUcode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<dynamic> getLoginData(String id, String password, BuildContext context) async {
    dynamic retData;

    final response = await DioClient().get(ServerInfo.REST_URL_USER_LOGIN + '/$id' + '/$password');

    if (response.data['code'] == '00') {
      retData = response.data['data'];
      return retData;
    }
    else if (response.data['code'] == '98') {
      ISAlert(context, '사용자정보 오류입니다.\n     - ${response.data['msg'].toString()}');
      return retData;
    }
    else {
      if (response == null)
        ISAlert(context, '통신 실패');
      else
        ISAlert(context, '아이디 또는 패스워드가 일치하지 않습니다.\n     - ${response.data['msg'].toString()}.');

      return null;
    }
  }

  Future<dynamic> getIdCheck(String id, BuildContext context) async {
    final response = await DioClient().get(ServerInfo.REST_URL_USER_CHECK + '/$id');

    if (response.data['code'] == '00') {
      return response.data['msg'];
    }
    else
      ISAlert(context, '중복체크가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
  }

  postData(dynamic data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_USER, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_USER, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getUserCodeName(String mcode, String level) async {
    final response = await DioClient().get(ServerInfo.REST_URL_USER_CODE_NAME + '?mcode=$mcode&level=$level');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

     return null;
  }

  postAddLoginLog(String ucode, String log_gbn, String ip, BuildContext context) async {
    final response = await DioClient().post(ServerInfo.REST_URL_USER_ADDLOGINLOG + '?ucode=$ucode&log_gbn=$log_gbn&ip=$ip');

    if (response.data['code'] != '00') {
      ISAlert(context, '로그 저장에 실패 했습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getEventHistoryData(String ucode, String page, String rows) async {
    List<dynamic> qDataEventHistoryList = [];

    qDataEventHistoryList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_USER_HIST + '/$ucode?page=$page&rows=$rows');

    if (response.data['code'] == '00') {
      qDataEventHistoryList.assignAll(response.data['data']);
    } else
      return null;

    return qDataEventHistoryList;
  }
}
