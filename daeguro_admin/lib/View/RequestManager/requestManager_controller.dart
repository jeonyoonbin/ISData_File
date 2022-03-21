
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RequestController extends GetxController with SingleGetTickerProviderMixin {
  static RequestController get to => Get.find();
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

  Future<List<dynamic>> getData(String mCode, String service_gbn, String status, String ucode, String cancel_req_yn, String page, String rows, String date_begin, String date_end) async {
    List<dynamic> qData = [];

    var result = await RestApiProvider.to
        .getRequestList(mCode, service_gbn, status, ucode, cancel_req_yn, page, rows, date_begin, date_end);

    total_count = int.parse(result.body['totalCount'].toString());
    totalRowCnt = int.parse(result.body['count'].toString());

    if (result.body['code'] == '00')
      qData.assignAll(result.body['data']);
    else
      return null;

    return qData;
  }

  getDetailData(String seq, BuildContext context) async {
    var result = await RestApiProvider.to.getServiceRequestDetail(seq);

    qDataDetail = result.body['data'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getServiceGbnItems() async {
    var result = await RestApiProvider.to.getServiceGbn();

    if (result.body['code'] != '00') {
      ISAlert(context, '회원사정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body['data'];
  }

  putServiceStatus(String seq, String status, String mod_ucode, String mod_name, BuildContext context) async {
    var result = await RestApiProvider.to.putServiceStatus(seq, status, mod_ucode, mod_name);

    if (result.body['code'] != '00') {
      ISAlert(context, '상태 변경에 실패 했습니다. \n관리자에게 문의 바랍니다.');
      return '';
    }

    return result.body['code'];
  }

  putServiceRequest(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putServiceRequest(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }
}
