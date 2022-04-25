
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RequestController extends GetxController with SingleGetTickerProviderMixin {
  static RequestController get to => Get.find();
  BuildContext context;

  int total_count = 0;
  int totalRowCnt = 0;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode, String service_gbn, String status, String ucode, String cancel_req_yn, String page, String rows, String date_begin, String date_end) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_REQUESTLIST +'?mCode=$mCode&service_gbn=$service_gbn&status=$status&ucode=$ucode&cancel_req_yn=$cancel_req_yn&page=$page&rows=$rows&date_begin=$date_begin&date_end=$date_end');

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    totalRowCnt = int.parse(response.data['count']);

    return qData;
  }

  Future<dynamic> getDetailData(String seq) async {
    final response = await DioClient().get(ServerInfo.REST_URL_REQUESTLIST + '/$seq');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<List<dynamic>> getServiceGbnItems() async {
    final response = await DioClient().get(ServerInfo.REST_URL_SERVICEGBN);

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  putServiceStatus(String seq, String status, String mod_ucode, String mod_name, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SERVICESTATUS + '/$seq?status=$status&mod_ucode=$mod_ucode&mod_name=$mod_name');

    if (response.data['code'] != '00') {
      ISAlert(context, '상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.');
      return '';
    }

    return response.data['code'];
  }

  putServiceRequest(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SERVICEREQUEST, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}
