import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/shop/shop_changepass.dart';
import 'package:daeguro_admin_app/Model/shop/shop_reviewStoreConfirm.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShopController extends GetxController with SingleGetTickerProviderMixin {
  static ShopController get to => Get.find();

  //List<dynamic> qData = [];
  ShopChangePassModel shopChangePass = ShopChangePassModel();

  //List<ResponseBodyApi> qData;
  dynamic qDataDetail;
  int total_count = 0;
  int totalRowCnt = 0;
  RxString raw = ''.obs;
  RxString page = ''.obs;
  String qDataShopCode;
  String image_status = '';
  String x = null;
  String y = null;
  String qDataReviewToken = '';
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  RxInt MainCount = 0.obs;
  RxInt SumMainCount = 0.obs;

  int reserTotalCnt = 0;
  int reserStatus10 = 0;
  int reserStatus12 = 0;
  int reserStatus30 = 0;
  int reserStatus40 = 0;
  int reserStatus90 = 0;

  int totalModiDataCnt = 0;
  int totalModiRowCnt = 0;

  dynamic qDataBasicInfo;

  //dynamic qDataInfo;
  //dynamic qDataCalcInfo;

  //List qDataBankItems = [];
  //List qDataDivItems = [];

  //List<dynamic> qDataMenuGroup = [];
  //List<dynamic> qDataMenuList = [];
  //List<dynamic> qDataOptionGroupList = [];
  //List<dynamic> qDataOptionList = [];
  //List<dynamic> qDataSectorList = [];
  //List<dynamic> qDataMenuOptionGroupList = [];

  //List<dynamic> qDataAddrSidoList = [];
  //List<dynamic> qDataAddrGunguList = [];
  //List<dynamic> qDataAddrDongList = [];
  //List<dynamic> qDataAddrRiList = [];

  //List<dynamic> qDataSaleDayTimeList = [];

  List<dynamic> qDataDeliTipTimeList = [];
  List<dynamic> qDataDeliTipCostList = [];
  List<dynamic> qDataDeliTipLocalList = [];

  //List<dynamic> qRegNoModificationList = [];

  //List<dynamic> qDataImageList = [];

  //List<dynamic> qDataOptionHistoryList = [];
  List<dynamic> qImageHistoryList = [];

  //List<dynamic> qDataEventHistoryList = [];
  //List<dynamic> qDataEventMenuList = [];

  //List<dynamic> qDeliTipHistoryList = [];

  dynamic qDataMenuGroupDetail;
  dynamic qDataMenuDetail;

  //dynamic qDataOptionGroupDetail;
  //dynamic qDataOptionDetail;

  //dynamic qDataSaleTime;
  dynamic qDataDeliTip;

  @override
  void onInit() {
    //print('[ShopController] onInit() call');

    Get.put(RestApiProvider());

    raw.value = '15';
    page.value = '1';

    //getData();

    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode, String value, String operator_code, String imageStatus, String reg_no_yn, String use_yn, String app_order_yn, String memo_yn, String img_yn, String reserve_yn, String reg_date, String _page, String _raw) async {
    //print('[ShopController] getData() call page= ' + page.toString() + ', rows = ' + raw.toString());

    List<dynamic> qData = [];

    // var result = await RestApiProvider.to.getShop(mCode, value, operator_code, imageStatus, reg_no_yn, use_yn, app_order_yn, memo_yn, img_yn, reg_date, _page, _raw);
    // total_count = int.parse(result.body['total_count'].toString());
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;

    //==================================================================================
    //Future<Response> getShop(String mCode, String searchinfo, String operator_code, String image_status, String reg_no_yn, String use_yn, String app_order_yn, String memo_yn, String img_yn, String reg_date, String page, String rows) =>

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOP + '?mCode=$mCode&keyword=$value&operator_code=$operator_code&image_status=$imageStatus&reg_no_yn=$reg_no_yn&use_yn=$use_yn&app_order_yn=$app_order_yn&memo_yn=$memo_yn&img_yn=$img_yn&reserve_yn=$reserve_yn&reg_date=$reg_date&page=$_page&rows=$_raw');

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

  Future<List<dynamic>> getModificationRegNoData() async {
    List<dynamic> qRegNoModificationList = [];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMODIFICATIONREGNO + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    //var result = await RestApiProvider.to.getModificationRegNo(fromDate.value.toString(), toDate.value.toString(), page.value.toString(), raw.value.toString());
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      totalModiDataCnt = int.parse(response.data['totalCount'].toString());
      totalModiRowCnt = int.parse(response.data['count'].toString());

      qRegNoModificationList.assignAll(response.data['data']);
    }
    else
      return null;

    return qRegNoModificationList;
  }

  putImageStatus(String shop_cd, String status, BuildContext context) async {
    var result = await RestApiProvider.to.putImageStatus(shop_cd, status);
    //print('[ShopController] putShopBasic() call');

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataHistoryList = [];
    //var result = await RestApiProvider.to.getHistory(shopCode, page, rows);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPHISTORY + '/$shopCode?page=$page&rows=$rows');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataHistoryList;
  }

  Future<List<dynamic>> getFranchiseListData() async {
    List<dynamic> qDataList = [];
    //var result = await RestApiProvider.to.getFranchiseList();

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPFRANCHISELIST);
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataList;
  }

  Future<List<dynamic>> getOptionHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    //var result = await RestApiProvider.to.getOptionHistory(shopCode, page, rows);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_OPTIONHISTORY + '/$shopCode?page=$page&rows=$rows');
    dio.clear();
    dio.close();

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionHistoryList;
  }

  Future<dynamic> getBasicData(String shopCode) async {
    //print('[ShopController] getData() call page= ' + page.toString() + ', rows = ' + raw.toString());

    String ucode = GetStorage().read('logininfo')['uCode'];

    //var result = await RestApiProvider.to.getShopBasic(shopCode, ucode);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPBASIC + '/$shopCode?ucode=$ucode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataBasicInfo = response.data['data'];
    }
    else{
      return null;
    }

    return qDataBasicInfo;
  }

  Future<List<dynamic>> getMemoHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    //var result = await RestApiProvider.to.getOptionHistory(shopCode, page, rows);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMEMOHISTORY + '/$shopCode?page=1&rows=1000');
    dio.clear();
    dio.close();

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionHistoryList;
  }

  postBasicData(String mCode, Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopBasic(data);
    //print('===== ret body str->'+result.bodyString.toString());

    qDataShopCode = result.body['shopCd'].toString();
    // {"code": "00",
    // "msg": "정상",
    // "shopCd": "853"}

    getData(mCode, '', '', '', '', '', '', '', '', '', '', page.value.toString(), raw.value.toString());

    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    return result.body;
  }

  putBasicData(String mCode, Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopBasic(data);

    getData(mCode, '', '', '', '', '', '', '', '', '', '', page.value.toString(), raw.value.toString());

    return result.body;
  }

  getNaverData(String address1, String address2) async {
    x = null;
    y = null;

    var result = await RestApiProvider.to.getNaver(address1);

    // 주소가 제대로 입력안될시 저장안됨. POS 매핑때문에 좌표값(x,y) 이 필수로 들어가야됨
    if (result.body['addresses'] == null || result.body['meta']['count'] == 0) {
      var result2 = await RestApiProvider.to.getNaver(address2);

      if (result2.body['addresses'] == null || result2.body['meta']['count'] == 0) {
        return;
      }
      else {
        qDataBasicInfo = result2.body['addresses'];

        x = qDataBasicInfo[0]['x'];
        y = qDataBasicInfo[0]['y'];
      }
    }
    else {
      qDataBasicInfo = result.body['addresses'];

      x = qDataBasicInfo[0]['x'];
      y = qDataBasicInfo[0]['y'];
    }
  }

  getReviewToken() async {
    //print('------ getReviewToken start');
    Map bodyData = {
      'cmd': 'get_token',
      'body': '{ "member_company_code" : "daegu" }'
    };

    var result = await RestApiProvider.to.postReviewToken(bodyData);
    //print('------ ret Data:' + result.bodyString.toString());
    //print('------ getReviewToken end');
  }

  //미사용
  getReviewShopInfo(String shopCd) async {
    //print('------ getReviewShopInfo start');
    Map bodyData = {
      'cmd': 'select_store',
      'body': '{ "store_code" : "' +
          shopCd +
          '", "member_company_code" : "daegu", "cc_code" : "" }'
    };

    var result = await RestApiProvider.to.postReviewShopInfo(bodyData);
    //print('------ ret Data:' + result.bodyString.toString());
    //print('------ getReviewShopInfo end');
  }

  postReviewStoreRegData(ShopReviewStoreConfirmModel data, BuildContext context) async {
    //print('------ postReviewStoreRegData start');
    String bodyObjText = '{"store_code": "' +
        data.store_code +
        '", "store_sub_idx": "' +
        data.store_sub_idx +
        '", "member_company_code": "' +
        data.member_company_code +
        '", "store_name": "' +
        data.store_name +
        '", "owner": "' +
        data.owner +
        '", "addr1": "' +
        data.addr1 +
        '", "addr2": "' +
        data.addr2 +
        '", "tel_num": "' +
        data.tel_num +
        '", "email": "' +
        data.email +
        '", "memo": "' +
        data.memo +
        '", "user_id": "' +
        data.user_id +
        '"}';

    //print(bodyObjText);

    Map bodyData = {'cmd': 'reg_store', 'body': bodyObjText};

    var result = await RestApiProvider.to.postReviewShopRegi(bodyData);

    print('------ ret Data:' + result.body.toString());

    if (result.body['statusCode'].toString() != '200') {
      ISAlert(context, '리뷰 등록에 실패 했습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getInfoData(String shopCode) async {
    //var result = await RestApiProvider.to.getShopInfo(shopCode);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPINFO + '/$shopCode');
    dio.clear();
    dio.close();

    //print('===== before getInfoData()-> '+ result.body['data'].toString());

    if (response.data['code'] == '00') {
      return response.data['data'];
    }
    else
      return null;
  }

  putInfoData(int mCode, String ccCode, Map data, BuildContext context) async {
    shopChangePass.job_gbn = '3';
    shopChangePass.mcode = mCode;
    shopChangePass.cccode = ccCode;
    shopChangePass.shop_cd = int.parse(data['shopCd']);
    shopChangePass.id = data['shopId'];
    shopChangePass.current = data['current'];
    shopChangePass.password = data['shopPass'];
    shopChangePass.mod_code = int.parse(data['modUCode']);
    shopChangePass.mod_user = data['modName'];

    // print(shopChangePass.toJson());

    await RestApiProvider.to.postRestError('0', '/admin/ShopInfo : putInfoData', '[POS 가맹점 비밀번호 변경 요청] ' + shopChangePass.toJson().toString());

    var _changePassResult = await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());

    await RestApiProvider.to.postRestError('0', '/admin/ShopInfo : putInfoData', '[POS 가맹점 비밀번호 변경 요청 결과] ' + shopChangePass.toJson().toString() + ' || ' + _changePassResult.body.toString());

    if (_changePassResult.body['code'] != '00') {
      ISAlert(context, '가맹점 비밀번호 변경 실패. \n\n관리자에게 문의 바랍니다');
    }
    else {
      var result = await RestApiProvider.to.putShopInfo(data);

      if (result.body['code'] != '00') {
        ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');

        // POS, 사장님 DB 원래대로 원복 ( 비밀번호 )
        shopChangePass.current = data['shopPass'];
        shopChangePass.password = data['current'];

        await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());
      }
    }

    // if (data['current'] == data['shopPass']) {
    //   var result = await RestApiProvider.to.putShopInfo(data);
    //
    //   if (result.body['code'] != '00') {
    //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   }
    // } else {
    //   await RestApiProvider.to.postRestError(
    //       '0', '/admin/ShopInfo : putInfoData', '[POS 가맹점 비밀번호 변경 요청] ' + shopChangePass.toJson().toString());
    //
    //   var _changePassResult =
    //       await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());
    //
    //   await RestApiProvider.to.postRestError(
    //       '0', '/admin/ShopInfo : putInfoData', '[POS 가맹점 비밀번호 변경 요청 결과] ' + shopChangePass.toJson().toString() + ' || ' + _changePassResult.body.toString());
    //
    //   if (_changePassResult.body['code'] != '00') {
    //     ISAlert(context, '가맹점 비밀번호 변경 실패. \n\n관리자에게 문의 바랍니다');
    //   } else {
    //     var result = await RestApiProvider.to.putShopInfo(data);
    //
    //     if (result.body['code'] != '00') {
    //       ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //
    //       // POS, 사장님 DB 원래대로 원복 ( 비밀번호 )
    //       shopChangePass.current = data['shopPass'];
    //       shopChangePass.password = data['current'];
    //
    //       await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());
    //     }
    //   }
    // }
  }

  getImageHistoryData(String shopCode, String page, String rows) async {
    qImageHistoryList.clear();

    var result = await RestApiProvider.to.getImageHistory(shopCode, page, rows);

    qImageHistoryList.assignAll(result.body['data']);
  }

  Future<dynamic> getCalcData(String shopCode) async {
    dynamic qDataCalcInfo;
    //var result = await RestApiProvider.to.getShopCalc(shopCode);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPCALC + '/$shopCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataCalcInfo = response.data['data'];
    }
    else
      return null;

    return qDataCalcInfo;
  }

  Future<String> putCalcData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopCalc(data);

    if (result.body['code'] == '00') {
      return result.body['code'].toString();
    } else {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['code'].toString();
    }

    //getData();
  }

  Future<String> postCalcConfirmData(Map data, Map formData, String selected_shopCode, BuildContext context) async {
    print(data);
    print('------=-=-=-=');
    print(formData.toString());
    print('------=-=-=-=');

    var result = await RestApiProvider.to.postShopCalcConfirm(data);
    print(result);

    var decodeBody = jsonDecode(result.body);
    print(decodeBody);

    if (decodeBody['code'] == '0000') {
      formData['modUCode'] = GetStorage().read('logininfo')['uCode'];
      formData['modName'] = GetStorage().read('logininfo')['name'];
      //print('formData--> '+formData.toJson().toString());

      await ISProgressDialog(context).dismiss();

      ShopController.to.putCalcData(formData, context).then((value) {
        if (value == '00') {
          ShopController.to.postSetBankConfirm(selected_shopCode, 'Y', context);

          //Navigator.pop(context, true);
        } else
          ShopController.to.postSetBankConfirm(selected_shopCode, 'N', context);
      });
    } else {
      await ISProgressDialog(context).dismiss();
      ShopController.to.postSetBankConfirm(selected_shopCode, 'N', context);

      //print(decodeBody);

      ISAlert(context, '계좌 인증 오류 - [' + decodeBody['code'].toString() + ']\n\n' + decodeBody['msg'].toString() + ' 입니다.');
    }
  }

  postSetBankConfirm(String shopCode, String confirmYn, BuildContext context) async {
    var result = await RestApiProvider.to.postSetBankConfirm(shopCode, confirmYn);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
    //getData();
  }

  Future<String> postChargeJoin(String shopCode, String ucode, BuildContext context) async {
    var result = await RestApiProvider.to.postChargeJoin(shopCode, ucode);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다\n\n - ' + result.body['msg'].toString());
      return result.body['code'].toString();
    }

    return result.body['code'].toString();
  }

  postData(Map data) async {
    // await RestApiProvider.to.postShop(data);
    // print('[ShopController] postData() call');
    //
    // getData();
  }

  Future<List<dynamic>> getMenuGroupData(String shopCode) async {
    List<dynamic> qDataMenuGroup = [];
    //print('[ShopController] getData() call page= ' + page.toString() + ', rows = ' + raw.toString());
    //qDataMenuGroup.clear();
    //var result = await RestApiProvider.to.getShopMenuGroup(shopCode);

    //qDataMenuGroup.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENUGROUP + '?shopCd=$shopCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataMenuGroup.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuGroup;
  }

  Future<dynamic> getMenuGoupDetailData(String menuGroupCd) async {
    //print('[ShopController] getMenuDetailData() call menuCd= ' + menuCd.toString());
    //qDataMenuGroupDetail.clear();

    //var result = await RestApiProvider.to.getShopMenuGroupDetail(menuGroupCd);

    //print('===== getMenuDetailData()-> '+ result.bodyString.toString());

    //qDataMenuGroupDetail = result.body['data'];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENUGROUP + '/$menuGroupCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataMenuGroupDetail = response.data['data'];
    }
    else
      return null;

    return qDataMenuGroupDetail;
  }

  postMenuGroupDetailData(String shopCode, Map data, BuildContext context) async {
    //print('[ShopController] postMenuGroupDetailData() call->'+data.toString());
    var result = await RestApiProvider.to.postShopMenuGroupDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //getMenuGroupData(shopCode);
  }

  putMenuGroupDetailData(String shopCode, Map data, BuildContext context) async {
    //print('[ShopController] putMenuGroupDetailData() call->'+data.toString());
    var result = await RestApiProvider.to.putShopMenuGroupDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //getMenuGroupData(shopCode);
  }

  Future<List<dynamic>> getMenuListData(String menuGroupCd) async {
    List<dynamic> qDataMenuList = [];

    //print('[ShopController] getMenuListData() call menuGroupCd= ' + menuGroupCd.toString()+', qDataMenuList Length:'+qDataMenuList.length.toString());
    qDataMenuList.clear();

    //var result = await RestApiProvider.to.getShopMenuList(menuGroupCd);

    //print('===== getMenuListData()-> '+ result.bodyString.toString());

    //qDataMenuList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENULIST + '/$menuGroupCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataMenuList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuList;
  }

  putMenuCopyData(String menuCd, String uName, Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopMenuCopy(menuCd, uName, data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //getMenuGroupData(shopCode, '', '');
  }

  updateMenuSort(String div, dynamic data, BuildContext context) async {
    var result = await RestApiProvider.to.postMenuSort(div, data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getMenuDetailData(String menuCd) async {
    //print('[ShopController] getMenuDetailData() call menuCd= ' + menuCd.toString());
    //qDataMenuDetail.clear();

    //var result = await RestApiProvider.to.getShopMenuDetail(menuCd);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENUDETAIL + '/$menuCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataMenuDetail = response.data['data'];
    }
    else
      return null;

    return qDataMenuDetail;
  }

  postMenuDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopMenuDetail(data);

    if (result.body['code'] != '00') {
      //ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      ISAlert(context, result.body['msg']);
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  putMenuDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopMenuDetail(data);

    if (result.body['code'] != '00') {
      //ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      ISAlert(context, result.body['msg']);
    }

    //getMenuGroupData(shopCode, '', '');
  }

  Future<List<dynamic>> getOptionGroupData(String shopCode, String menuCode) async {
    List<dynamic> qDataOptionGroupList = [];

    qDataOptionGroupList.clear();

    //var result = await RestApiProvider.to.getShopOptionGroup(shopCode, menuCode);

    //qDataOptionGroupList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '?shopCd=$shopCode&menuCd=$menuCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataOptionGroupList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionGroupList;
  }

  Future<dynamic> getOptionGroupDetailData(String optionGroupCd) async {
    dynamic qDataOptionGroupDetail;

    //var result = await RestApiProvider.to.getShopOptionGroupDetail(optionGroupCd);

    //qDataOptionGroupDetail = result.body['data'];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '/$optionGroupCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataOptionGroupDetail = response.data['data'];
    }
    else
      return null;

    return qDataOptionGroupDetail;
  }

  putOptionGroupDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopOptionGroupDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //print('[ShopController] putMenuOptionData() call');

    //getMenuGroupData(shopCode, '', '');
  }

  postOptionGroupDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopOptionGroupDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  deleteOptionGroupDetailData(String optionGroupCd, BuildContext context) async {
    var result = await RestApiProvider.to.deleteShopOptionGroupDetail(optionGroupCd);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  postCopyOptionGroupData(String shopCd, String optionGroupCd, String uName, BuildContext context) async {
    //print('postCopyOptionGroupData --> shopCd: $shopCd, optionGroupCd: $optionGroupCd, uName: $uName');
    var result = await RestApiProvider.to.postShopCopyOptionGroup(shopCd, optionGroupCd, uName);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getOptionData(String optionGroupCd) async {
    List<dynamic> qDataOptionList = [];

    qDataOptionList.clear();

    //var result = await RestApiProvider.to.getShopOptionList(optionGroupCd);

    //qDataOptionList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPOPTIONLIST + '/$optionGroupCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataOptionList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionList;
  }

  Future<dynamic> getOptionDetailData(String optionCd) async {
    dynamic qDataOptionDetail;

    //var result = await RestApiProvider.to.getShopOptionDetail(optionCd);

    //qDataOptionDetail = result.body['data'];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPOPTIONDETAIL + '/$optionCd');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataOptionDetail = response.data['data'];
    }
    else
      return null;

    return qDataOptionDetail;
  }

  postOptionDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopOptionDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  putOptionDetailData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putShopOptionDetail(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //print('[ShopController] putMenuOptionData() call');

    //getMenuGroupData(shopCode, '', '');
  }

  deleteOptionDetailData(String optionCd, BuildContext context) async {
    var result = await RestApiProvider.to.deleteShopOptionDetail(optionCd);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  Future<List<dynamic>> getMenuOptionGroupData(String menuCode) async {
    List<dynamic> qDataMenuOptionGroupList = [];

    qDataMenuOptionGroupList.clear();

    //var result = await RestApiProvider.to.getShopMenuOptionGroup(menuCode);
    //qDataMenuOptionGroupList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '/$menuCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataMenuOptionGroupList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuOptionGroupList;
  }

  postMenuOptionGroupData(String menuCode, dynamic data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopMenuOptionGroup(menuCode, data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  deleteMenuOptionGroupData(String menuOptionGroupCd, BuildContext context) async {
    var result = await RestApiProvider.to.deleteShopMenuOptionGroup(menuOptionGroupCd);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
  }

  Future<List<dynamic>> getMenuNameListData(String shopCode, String keyword) async {
    List<dynamic> tempRetData = [];

    //var result = await RestApiProvider.to.getMenuNameList(shopCode, keyword);

    //tempRetData.assignAll(result.body['data']);

    //return tempRetData;

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPMENUNAMELIST + '?shopCd=$shopCode&keyword=$keyword');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      tempRetData.assignAll(response.data['data']);
    }
    else
      return null;

    return tempRetData;
  }

  Future<List<dynamic>> getShopNameListData(String mCode, String keyword) async {
    List<dynamic> tempRetData = [];

    //var result = await RestApiProvider.to.getShopNameList(mCode, keyword);

    //tempRetData.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPSHOPNAMELIST + '?mcode=$mCode&keyword=$keyword');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      tempRetData.assignAll(response.data['data']);
    }
    else
      return null;

    return tempRetData;
  }

  deleteRemoveMenuOptionData(String shopCode, BuildContext context) async {
    var result = await RestApiProvider.to.deleteRemoveMenuOption(shopCode);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<String> postCopyMenuOptionData(String srcCcode, String srcShopCd, String destCcode, String destShopCd, String uName, BuildContext context) async {
    print('srcCcode:$srcCcode, srcShopCd:$srcShopCd, destCcode:$destCcode, destShopCd:$destShopCd, uName: $uName');

    var result = await RestApiProvider.to.postCopyMenuOption(srcCcode, srcShopCd, destCcode, destShopCd, uName);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['code'].toString();
    }

    return result.body['code'].toString();
  }

  putMenuComplete(String shopCd, String menuComplete, Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putMenuComplete(shopCd, menuComplete, data);

    // print(result.body);
    if (result.body['code'] != '00') {
      ISAlert(context, '?뺤긽?곸쑝濡?????섏? ?딆븯?듬땲?? \n\n愿由ъ옄?먭쾶 臾몄쓽 諛붾엻?덈떎');
    }
  }

  Future<List<dynamic>> getSectorData(String shopCode) async {
    List<dynamic> qDataSectorList = [];

    qDataSectorList.clear();
    //var result = await RestApiProvider.to.getShopSector(shopCode);
    //qDataSectorList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPSECTOR + '/$shopCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataSectorList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataSectorList;
  }

  Future<List<dynamic>> getSectorhistoryData(String shopCode) async {
    List<dynamic> qDataSectorList = [];

    qDataSectorList.clear();
    //var result = await RestApiProvider.to.getShopSector(shopCode);
    //qDataSectorList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPSECTORHIST + '/$shopCode?page=1&rows=100');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataSectorList.assignAll(response.data['data']);
    } else
      return null;

    return qDataSectorList;
  }

  postSectorData(String shopCode, String sidoName, String gunguName, dynamic data, BuildContext context) async {
    //print('[ShopController] postSectorData() call shopCode= ' + shopCode.toString() +', sidoName='+sidoName+', gunguName='+gunguName+', map='+data.toString());
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.postShopSector(shopCode, sidoName, gunguName, uCode, uName, data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //getSectorData(shopCode);
  }

  deleteSectorData(String shopCode, String sidoName, String gunguName, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.deleteShopSector(shopCode, sidoName, gunguName, uCode, uName);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    // print('[ShopController] postData() call');
    //
    //getMenuGroupData(shopCode, '', '');
    //getSectorData(shopCode);
  }

  Future<List<dynamic>> getSidoData() async {
    List<dynamic> qDataAddrSidoList = [];

    qDataAddrSidoList.clear();
    //var result = await RestApiProvider.to.getSidoCode();
    //qDataAddrSidoList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SIDO_CODE);
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataAddrSidoList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataAddrSidoList;
  }

  Future<List<dynamic>> getGunguData(String sido) async {
    List<dynamic> qDataAddrGunguList = [];

    qDataAddrGunguList.clear();
    //var result = await RestApiProvider.to.getGunguCode(sido);

    //qDataAddrGunguList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_GUNGU_CODE + '/$sido');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataAddrGunguList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataAddrGunguList;
  }

  Future<List<dynamic>> getDongData(String sido, String gungu) async {
    List<dynamic> qDataAddrDongList = [];

    qDataAddrDongList.clear();
    //var result = await RestApiProvider.to.getDongCode(sido, gungu);

    //qDataAddrDongList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DONG_CODE + '/$sido/$gungu');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataAddrDongList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataAddrDongList;
  }

  Future<List<dynamic>> getRiData(String sido, String gungu, String dong) async {
    List<dynamic> qDataAddrRiList = [];

    qDataAddrRiList.clear();
    //var result = await RestApiProvider.to.getRiCode(sido, gungu, dong);
    //qDataAddrRiList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_RI_CODE + '/$sido/$gungu/$dong');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataAddrRiList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataAddrRiList;
  }

  Future<dynamic> getSaleTimeData(String shopCode) async {
    dynamic qDataSaleTime;

    //var result = await RestApiProvider.to.getSaleTime(shopCode);
    //qDataSaleTime = result.body['data'];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SALETIME + '/$shopCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataSaleTime = response.data['data'];
    }
    else
      return null;

    return qDataSaleTime;
  }

  Future<dynamic> postSaleTimeData(Map data) async {
    try{
      var dio = Dio();
      final response = await dio.post(ServerInfo.REST_URL_SET_SALETIME,
        data: data,
        // options: Options(headers: {
        //   'Content-Type': 'application/json'
        // })
      );

      //print('postSaleTimeData statusMessage[${response.statusCode.toString()}]:${response.statusMessage.toString()}');
      //print('postSaleTimeData response:${response.toString()}');

      dio.clear();
      dio.close();

      if (response.data['code'] != '00') {
        return response.data['msg'];
      }
      else
        return null;
    } catch (e){
      print('postSaleTimeData e:${e.toString()}');

      return e.toString();
    }
  }

  putDayTimeData(String shopCode, dynamic data, BuildContext context) async {
    var result = await RestApiProvider.to.putDayTime(shopCode, data);
    //print('===== before putDayTimeData()-> ' + result.bodyString.toString());
    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getSaleDayTimeData(String shopCode, String tipGbn) async {
    List<dynamic> qDataSaleDayTimeList = [];

    qDataSaleDayTimeList.clear();
    //var result = await RestApiProvider.to.getSaleDateTime(shopCode, tipGbn);

    //qDataSaleDayTimeList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DELITIP + '?shopCd=$shopCode&tipGbn=$tipGbn');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataSaleDayTimeList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataSaleDayTimeList;
  }

  getDeliTipData(String shopCode, String tipGbn) async {
    //print('[ShopController] getSectorData() call shopCode= ' + shopCode.toString());
    var result = await RestApiProvider.to.getDeliTip(shopCode, tipGbn);

    //print('===== before getDeliTipData()-> '+ result.body['data'].toString());

    if (tipGbn == '7') {
      qDataDeliTipTimeList.clear();
      qDataDeliTipTimeList.assignAll(result.body['data']);
    } else if (tipGbn == '3') {
      qDataDeliTipCostList.clear();
      qDataDeliTipCostList.assignAll(result.body['data']);
    } else if (tipGbn == '9') {
      qDataDeliTipLocalList.clear();
      qDataDeliTipLocalList.assignAll(result.body['data']);
    }
  }

  Future<List<dynamic>> getDeliTipHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDeliTipHistoryList = [];

    qDeliTipHistoryList.clear();

    //var result = await RestApiProvider.to.getDeliTipHistory(shopCode, page, rows);

    //qDeliTipHistoryList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DELITIPHISTORY + '/$shopCode?page=$page&rows=$rows');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDeliTipHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDeliTipHistoryList;
  }

  putDeliTipData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putDeliTip(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postDeliTipData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postDeliTip(data);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteDeliTipData(String tipSeq, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.deleteDeliTip(tipSeq, uCode, uName);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  // setReserve(String shop_cd, String reserve_yn, BuildContext context) async {
  //   var dio = Dio();
  //   final response = await dio.put(ServerInfo.REST_URL_DELITIPSETRESERVE + '?shop_cd=$shop_cd&reserve_yn=$reserve_yn&modUCode=${GetStorage().read('logininfo')['uCode']}&modName=${GetStorage().read('logininfo')['name']}');
  //
  //   //print('response-->${response.toString()}'); //response-->{"code":"00","msg":"정상","num":"1","err":"0"}
  //   dio.clear();
  //   dio.close();
  //
  //   if (response.data['code'] != '00') {
  //     ISAlert(context, '정상적으로 예약 설정이 되지 않았습니다.. \n\n관리자에게 문의 바랍니다');
  //   }
  // }

  Future<dynamic> setReserveShopInfoadmin(Map bodyData) async {
    try{
      //print('setReserveShopInfoadmin bodyData:${bodyData.toString()}');
      var dio = Dio();
      final response = await dio.post(ServerInfo.REST_RESERVEURL+'/shopInfo-admin',//'https://reser.daeguro.co.kr:10008/shopInfo-admin',
          data: bodyData.toString(),
          options: Options(headers: {
            'Authorization':
            'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTQwIiwiSWQiOiJ0ZXN0Y3VzdDAxQG5hdmVyLmNvbSIsIklkR2JuIjoiQSIsImp0aSI6Ijg0NTU2YTJjLTA5NTgtNGM0MS04YzdmLTk5NzZhMTZjNTU3OSIsIm5iZiI6MTYyMTkzNzc0OSwiZXhwIjoxNjIxOTM3OTI5LCJpYXQiOjE2MjE5Mzc3NDl9.LXMrAEn0nFeA12-ALUPouwVHJ2DxXN_eRUCnFxSjGsU',
            'Content-Type': 'application/json'
          }));

      dio.clear();
      dio.close();

      //print('setReserveShopInfoadmin statusMessage[${response.statusCode.toString()}]:${response.statusMessage.toString()}');
      //print('setReserveShopInfoadmin response:${response.toString()}');

      if (response.data['code'] != '00') {
        return response.data['msg'];
      }
      else
        return null;

    } catch (e){
      print('setReserveShopInfoadmin e:${e.toString()}');

      return e.toString();
    }



    // if (response.data['code'] != '00') {
    //   //ISAlert(context, '정상적으로 예약 설정이 되지 않았습니다.. \n\n관리자에게 문의 바랍니다');
    //   return response.data['msg'];
    // }
    // else{
    //   return null;
    // }
  }

  Future<List<dynamic>> getReserItems(String div) async {
    List<dynamic> itemsList = [];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_RESERVEURL+'/items-list?item=${div}');//('https://reser.daeguro.co.kr:10008/items');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      itemsList = response.data['data'];
    else
      return null;

    return itemsList;
  }

  Future<dynamic> getReserShopInfo(String shopCode) async {
    dynamic qData;

    //var result = await RestApiProvider.to.getSaleTime(shopCode);
    //qDataSaleTime = result.body['data'];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_RESERVEURL+'/shopInfo?shopCd=$shopCode');//'https://reser.daeguro.co.kr:10008/shopInfo?shopCd=$shopCode');
    dio.clear();
    dio.close();

    //print('getReserShopInfo -> ${response.data['data']}');

    if (response.data['code'] == '00') {
        qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  postDeleteFile(String ccCode, String shopCode, String kind, String file_name, BuildContext context) async {
    //print('[ShopController] postDeleteFile() call');
    //print('[ShopController] ccCode : $ccCode, shopCode : $shopCode, kind : $kind, file_name : $file_name');

    var result = await RestApiProvider.to.postShopDeleteFile(shopCode, kind, file_name);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    //getDetailData(ccCode);
  }

  Future<List<dynamic>> getImageData(String shopCode) async {
    List<dynamic> qDataImageList = [];

    qDataImageList.clear();
    //var result = await RestApiProvider.to.getImage(shopCode);

    //qDataImageList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_IMAGE + '?shop_cd=$shopCode');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataImageList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataImageList;
  }

  // getImageThumbData(String cccode, String shopCode, String file_name,
  //     String width, String height) async {
  //   //print('[ShopController] getSectorData() call shopCode= ' + shopCode.toString());
  //
  //   var result = await RestApiProvider.to.getThumbImage(cccode, shopCode, file_name, width, height);
  //
  //   //print('===== before getSectorData()-> '+ result.body['data'].toString());
  // }

  // putImageData(Map data, BuildContext context) async {
  //   //var result = await RestApiProvider.to.putCloseDateTime(data);
  //
  //   // if (result.body['code'] != '00') {
  //   //   ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   // }
  // }

  putMenuImageRemove(BuildContext context, String menuCode, String ccCode, String shopCode) async {
    var result = await RestApiProvider.to.putMenuImageRemove(menuCode, ccCode, shopCode);

    //print('===== putMenuImageRemove()-> '+ result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 처리 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postImageData(Map data, BuildContext context) async {
    //var result = await RestApiProvider.to.postImage(div, cccode, shopCode, menuName, data);

    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }
  }

  Future<List> getDataBankItems() async {
    List qDataBankItems = [];

    qDataBankItems.clear();
    //var result = await RestApiProvider.to.getBankCode();

    //qDataBankItems.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_BANK_CODE);
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataBankItems.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataBankItems;
  }

  Future<List> getDataDivItems() async {
    List qDataDivItems = [];

    qDataDivItems.clear();
    //var result = await RestApiProvider.to.getDivCode();

    //qDataDivItems.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DIV_CODE);
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataDivItems.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataDivItems;
  }

  putRemoveShopImage(String cccode, String shop_cd, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.putRemoveShopImage(cccode, shop_cd, uCode, uName);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putUpdateImageStatus(String shop_cd, String status, BuildContext context) async {
    var result = await RestApiProvider.to.putUpdateImageStatus(shop_cd, status);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 상태변경이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postShopPosUpdate(dynamic data, BuildContext context) async {
    var result = await RestApiProvider.to.postShopPosUpdate(data);

    if (result.body['message'] != '성공') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getShopOrderCancelListData(String posYn, String gungu, String startDate, String endDate, String _page, String _raw) async {
    //print('[ShopController] getShopOrderCancelListData() call posYn=' + posYn.toString() + ', gungu=' + gungu.toString() + ', startDate=' + startDate.toString() + ', endDate=' + endDate.toString() + ', page=' + page.toString() + ', rows =' + raw.toString());

    List<dynamic> qData = [];

    var dio = Dio();
    //var result2 = await RestApiProvider.to.getShopOrderCancelList(posYn, gungu, startDate, endDate, _page, _raw);
    final result = await dio.get(ServerInfo.REST_URL_SHOPORDERCANCELLIST + '?pos_yn=$posYn&gungu=$gungu&date_begin=$startDate&date_end=$endDate&page=$_page&rows=$_raw');

    dio.clear();
    dio.close();

    //print(result.data);

    //print('===== getData()-> '+ result.bodyString.toString());

    total_count = int.parse(result.data['totalCount'].toString());
    totalRowCnt = int.parse(result.data['count'].toString());

    //qData.assignAll(result.body['data']);

    if (result.data['code'] == '00')
      qData.assignAll(result.data['data']);
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getshopeventlist(String mCode, String shopName, String state, String date_begin, String date_end, String _page, String _raw) async {
    List<dynamic> qData = [];

    date_begin = date_begin.toString().replaceAll('-', '');
    date_end = date_end.toString().replaceAll('-', '');

    //var result = await RestApiProvider.to.getShopEventList(mCode, shopName, state, date_begin, date_end, _page, _raw);
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPEVENTLIST + '?mCode=$mCode&shopName=$shopName&state=$state&date_begin=$date_begin&date_end=$date_end&page=$_page&rows=$_raw');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00'){
      total_count = int.parse(response.data['totalCount'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getEventHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataEventHistoryList = [];

    qDataEventHistoryList.clear();

    //var result = await RestApiProvider.to.getEventHistory(shopCode, page, rows);

    //qDataEventHistoryList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPEVENTHIST + '/$shopCode?page=$page&rows=$rows');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataEventHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataEventHistoryList;
  }

  Future<List<dynamic>> getEventMenuData(String shopCode, String state, String page, String rows) async {
    List<dynamic> qDataEventMenuList = [];

    qDataEventMenuList.clear();

    //var result = await RestApiProvider.to.getEventMenu(shopCode, state, page, rows);

    //qDataEventMenuList.assignAll(result.body['data']);

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_SHOPEVENTMENU + '/$shopCode?state=$state&page=$page&rows=$rows');
    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qDataEventMenuList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataEventMenuList;
  }

  putMoveReview(BuildContext context, String fromShopCode, String toShopCode) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String uname = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.putMoveReview(fromShopCode, toShopCode, ucode, uname);

    await RestApiProvider.to.postRestError('0', '/admin/ShopReview : putMoveReview',
        '[리뷰 이관 요청] fromShopCode : $fromShopCode, toShopCode : $toShopCode, ucode : $ucode, uname : $uname || return : [' + result.body['code'] + '] ' + result.body['msg']);

    // print('===== putMoveReview()-> '+ result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 처리되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<String> getEventYn(String shopCd) async {
    var result = await RestApiProvider.to.getEventYn(shopCd);

    return result.body['data'];
  }

  Future<String> putShopContractEnd(BuildContext context, String shopCd, String date_end_contract) async {
    var result = await RestApiProvider.to.putShopContractEnd(shopCd, date_end_contract);

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다\n\n - ' + result.body['msg'].toString());
      return result.body['code'].toString();
    }

    return result.body['code'].toString();
  }

  Future<List<dynamic>> getReserListData(
      String shopCd, String dateBegin, String dateEnd, String status, String jobGbn, String searchInfo, String page, String pageRows) async {
    List<dynamic> qData = [];

    var dio = Dio();

    final result = await dio.get(//static const String REST_URL_RESER_LIST = "https://reser.daeguro.co.kr:10008/reser-list";
        ServerInfo.REST_RESERVEURL + '/reser-list'+
            '/$status?shopCd=$shopCd&dateBegin=$dateBegin&dateEnd=$dateEnd&jobGbn=$jobGbn&searchInfo=$searchInfo&page=$page&pageRows=$pageRows',
        options: Options(headers: {
          'Authorization' : 'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTQwIiwiSWQiOiJ0ZXN0Y3VzdDAxQG5hdmVyLmNvbSIsIklkR2JuIjoiQSIsImp0aSI6Ijg0NTU2YTJjLTA5NTgtNGM0MS04YzdmLTk5NzZhMTZjNTU3OSIsIm5iZiI6MTYyMTkzNzc0OSwiZXhwIjoxNjIxOTM3OTI5LCJpYXQiOjE2MjE5Mzc3NDl9.LXMrAEn0nFeA12-ALUPouwVHJ2DxXN_eRUCnFxSjGsU',
          'Content-Type' : 'application/json'
        }));
    dio.clear();
    dio.close();

    totalRowCnt = int.parse(result.data['totalCnt'].toString());

    reserTotalCnt = result.data['totalCnt'];
    reserStatus10 = result.data['statuS10'];
    reserStatus12 = result.data['statuS12'];
    reserStatus30 = result.data['statuS30'];
    reserStatus40 = result.data['statuS40'];
    reserStatus90 = result.data['statuS90'];

    if (result.data['code'] == '00') {
      qData.assignAll(result.data['data']);
    } else
      return null;

    return qData;
  }

  Future<String> getDBRegCheck(int mcode, String buss_reg_no) async {
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DBREGCHECK + '?mcode=$mcode&reg_no=$buss_reg_no');

    dio.clear();
    dio.close();

    //print('getDBRegCheck response:${response.data.toString()}');

    //if (response.data['code'] != '00') {
    return response.data['data'];
    //}
  }

  // Future<String> getTaxRegCheck(String buss_reg_no) async {
  //   var dio = Dio();
  //   final response = await dio.get(ServerInfo.REST_URL_TAXREGCHECK + '?buss_reg_no=$buss_reg_no');
  //
  //   dio.clear();
  //   dio.close();
  //
  //   //if (response.data['code'] != '00') {
  //     return response.data['code'] + '|' +response.data['msg'];
  //   //}
  // }
}
