import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController with SingleGetTickerProviderMixin {
  static UserController get to => Get.find();
  //BuildContext context;

  //List<dynamic> qData = [];
  dynamic qDataDetail;
  //dynamic qDataLogin;
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

  String IdCheck = '';

  @override
  void onInit() {
    Get.put(RestApiProvider());

    //getData(context, '2');

    super.onInit();
  }

  Future<List<dynamic>> getData(BuildContext context, String mCode) async {
    // var result = await RestApiProvider.to.getUser(mCode, level.value, working.value, id_name.value, memo.value, page.value.toString(), raw.value.toString() );
    //
    // total_count = int.parse(result.body['total_count'].toString());
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // qData.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    List<dynamic> qData = [];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_USER + '?mCode=$mCode&level=${level.value}&working=${working.value}&id_name=${id_name.value}&memo=${memo.value}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

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

  getDetailData(String uCode, BuildContext context) async {
    String rUcode = GetStorage().read('logininfo')['uCode'];

    var result = await RestApiProvider.to.getUserDetail(uCode, rUcode);

    //qDataDetail.clear();


    qDataDetail = result.body['data'];

    if (result.body['code'] != '00') {
      ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
    }
  }

  Future<dynamic> getLoginData(String id, String password, BuildContext context) async {
    dynamic retData;

    var result = await RestApiProvider.to.getUserLogin(id, password);

    //print('===== getLoginData()-> '+ result.bodyString.toString());

    if (result.body['code'] == '00') {
      retData = result.body['data'];
      return retData;
    }
    else if (result.body['code'] == '98') {
      ISAlert(context, '휴대폰 번호가 정확하지 않습니다.\n     - 휴대폰 번호 확인 후, 재시도해주세요.');
      return retData;
    }
    else {
      if (result == null)
        ISAlert(context, '통신 실패');
      else
        ISAlert(context, '아이디 또는 패스워드가 일치하지 않습니다.\n     - 아이디, 패스워드 확인 후, 재시도해주세요.');

      return null;
    }
  }

  Future<bool> getOtpConfirmData(String uCode, String secCode, BuildContext context) async {
    dynamic retData;

    //print('===== getOtpConfirmData()-> uCode:${uCode}, secCode:${secCode}');

    var result = await RestApiProvider.to.getUserOtpConfirm(uCode, secCode);

    //print('===== getOtpConfirmData()-> '+ result.bodyString.toString());

    if (result.body['code'] == '00') {
      //retData = result.body['data'];
      return true;
    }
    else {
      if (result == null)
        ISAlert(context, '통신 실패');
      else
        ISAlert(context, '인증에 실패하였습니다.\n\n     - 인증 번호 확인 후, 재시도해주세요.');

      return false;
    }
  }

  getIdCheck(String id, BuildContext context) async {
    var result = await RestApiProvider.to.getIdCheck(id);

    IdCheck = result.body['msg'];

    if (result.body['code'] != '00') {
      ISAlert(context, '중복체크가 되지 않았습니다. \n\n관리자에게 문의 바랍니다.');
      //await EasyLoading.showError('사용자ID 또는 비밀번호를 확인하십시오', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
    }
  }

  postData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postUser(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // if (result.body['code'] != '00') {
    //   //await EasyLoading.showError(result.body['msg'].toString(), maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
    // }
    // else {
    //   //await EasyLoading.showSuccess(result.body['msg'].toString(), maskType: EasyLoadingMaskType.clear, duration: Duration(seconds: 3), dismissOnTap: true);
    // }
  }

  putData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putUser(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getUserCodeNameSaleseman(String mcode, String level) async {
    List<dynamic> qUserCodeName_SalesMan = [];
    var result = await RestApiProvider.to.getUserCodeName(mcode, level);

    //qUserCodeName_SalesMan = result.body['data'];

    // if (result.body['code'] != '00') {
    //   ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
    //   //await EasyLoading.showError('사용자ID 또는 비밀번호를 확인하십시오', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
    // }

    if (result.body['code'] == '00')
      qUserCodeName_SalesMan = result.body['data'];
    else
      return null;

    return qUserCodeName_SalesMan;
  }

  Future<List<dynamic>> getUserCodeNameOperator(String mcode, String level) async {
    List<dynamic> qUserCodeName_Operator = [];

    var result = await RestApiProvider.to.getUserCodeName(mcode, level);

    // if (result.body['code'] != '00') {
    //   ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
    //   //await EasyLoading.showError('사용자ID 또는 비밀번호를 확인하십시오', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
    // }

    if (result.body['code'] == '00')
      qUserCodeName_Operator = result.body['data'];
    else
      return null;

    return qUserCodeName_Operator;
  }

  postAddLoginLog(String ucode, String log_gbn, String ip, BuildContext context) async {
    var result = await RestApiProvider.to.getAddLoginLog(ucode, log_gbn, ip);

    if (result.body['code'] != '00') {
      ISAlert(context, '로그 저장에 실패 했습니다. \n\n관리자에게 문의 바랍니다');
    }

    // if (result.body['code'] != '00') {
    //   //await EasyLoading.showError(result.body['msg'].toString(), maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
    // }
    // else {
    //   //await EasyLoading.showSuccess(result.body['msg'].toString(), maskType: EasyLoadingMaskType.clear, duration: Duration(seconds: 3), dismissOnTap: true);
    // }
  }
}
