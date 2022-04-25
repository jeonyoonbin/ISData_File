import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shop_changepass.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/Network/DioClientPos.dart';
import 'package:daeguro_admin_app/Network/DioClientReserve.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShopController extends GetxController with SingleGetTickerProviderMixin {
  static ShopController get to => Get.find();

  ShopChangePassModel shopChangePass = ShopChangePassModel();

  //List<ResponseBodyApi> qData;
  dynamic qDataDetail;
  int total_count = 0;
  int totalRowCnt = 0;
  RxString raw = ''.obs;
  RxString page = ''.obs;

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

  List<dynamic> qDataDeliTipTimeList = [];
  List<dynamic> qDataDeliTipCostList = [];
  List<dynamic> qDataDeliTipLocalList = [];

  dynamic qDataMenuGroupDetail;
  dynamic qDataMenuDetail;
  dynamic qDataDeliTip;

  @override
  void onInit() {
    raw.value = '15';
    page.value = '1';

    super.onInit();
  }

  Future<List<dynamic>> getData(String mCode, String value, String operator_code, String shopStatus, String reg_no_yn, String use_yn, String app_order_yn, String memo_yn, String img_yn, String shop_type, String reg_date, String _page, String _raw) async {

    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOP + '?mCode=$mCode&keyword=$value&operator_code=$operator_code&shop_status=$shopStatus&reg_no_yn=$reg_no_yn&use_yn=$use_yn&app_order_yn=$app_order_yn&memo_yn=$memo_yn&img_yn=$img_yn&shop_type=$shop_type&reg_date=$reg_date&page=$_page&rows=$_raw');

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

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMODIFICATIONREGNO + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

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
    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOP_IMAGESTATUS + '?shop_cd=$shop_cd&status=$status');

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataHistoryList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPHISTORY + '/$shopCode?page=$page&rows=$rows');

    if (response.data['code'] == '00') {
      qDataHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataHistoryList;
  }

  Future<List<dynamic>> getFranchiseListData() async {
    List<dynamic> qDataList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPFRANCHISELIST);

    if (response.data['code'] == '00') {
      qDataList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataList;
  }

  Future<List<dynamic>> getOptionHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_OPTIONHISTORY + '/$shopCode?page=$page&rows=$rows');

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionHistoryList;
  }

  Future<dynamic> getBasicData(String shopCode) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPBASIC + '/$shopCode?ucode=$ucode');

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

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMEMOHISTORY + '/$shopCode?page=1&rows=1000');

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionHistoryList;
  }

  Future<dynamic> postBasicData(String mCode, dynamic data, BuildContext context) async {
    
    final response = await DioClient().post(ServerInfo.REST_URL_SHOPBASIC, data: data);

    print('postBasicData:${response.data.toString()}');

    //qDataShopCode = response.data['shopCd'].toString();

    getData(mCode, '', '', '', '', '', '', '', '', '', '', page.value.toString(), raw.value.toString());

    return response.data;
  }

  putBasicData(String mCode, dynamic data, BuildContext context) async {
    //var result = await RestApiProvider.to.putShopBasic(data);

    //
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPBASIC, data: data);

    //
    //

    getData(mCode, '', '', '', '', '', '', '', '', '', '', page.value.toString(), raw.value.toString());

    return response.data;
  }

  getNaverData(String address1, String address2) async {
    x = null;
    y = null;

    final response = await DioClient().get(ServerInfo.REST_URL_NAVER + '?address=$address1');

    // 주소가 제대로 입력안될시 저장안됨. POS 매핑때문에 좌표값(x,y) 이 필수로 들어가야됨
    if (response.data['addresses'] == null || response.data['meta']['count'] == 0) {
      final response2 = await DioClient().get(ServerInfo.REST_URL_NAVER + '?address=$address2');

      if (response2.data['addresses'] == null || response2.data['meta']['count'] == 0) {
        return;
      }
      else {
        qDataBasicInfo = response2.data['addresses'];

        x = qDataBasicInfo[0]['x'];
        y = qDataBasicInfo[0]['y'];
      }
    }
    else {
      qDataBasicInfo = response.data['addresses'];

      x = qDataBasicInfo[0]['x'];
      y = qDataBasicInfo[0]['y'];
    }
  }

  Future<dynamic> getInfoData(String shopCode) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPINFO + '/$shopCode?ucode=$ucode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }
    else
      return null;
  }

  putInfoData(int mCode, String ccCode, dynamic data, BuildContext context) async {
    shopChangePass.job_gbn = '3';
    shopChangePass.mcode = mCode;
    shopChangePass.cccode = ccCode;
    shopChangePass.shop_cd = int.parse(data['shopCd']);
    shopChangePass.id = data['shopId'];
    shopChangePass.current = data['current'];
    shopChangePass.password = data['shopPass'];
    shopChangePass.mod_code = int.parse(data['modUCode']);
    shopChangePass.mod_user = data['modName'];

    // 가맹점 등록 일 시 pos에 데이터 날리지 않음
    if (mCode == 0 && ccCode == '0') {
      var result = await DioClient().put(ServerInfo.REST_URL_SHOPINFO, data: data);

      if (result.data['code'] != '00') {
        ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
    }
    else {
      await DioClient().postRestLog('0', 'ShopInfo/posPassChange', '[POS 가맹점 비밀번호 변경 요청] ' + shopChangePass.toJson().toString());

      //var _changePassResult = await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());

      final response = await DioClient().post('https://ceo.daeguro.co.kr/Sync/MyPass', data: shopChangePass.toJson());

      await DioClient().postRestLog('0', 'ShopInfo/posPassChange', '[POS 가맹점 비밀번호 변경 요청 결과] ' + shopChangePass.toJson().toString() + ' || ' + response.data.toString());

      if (response.data['code'] != '00') {
        ISAlert(context, '가맹점 비밀번호 변경 실패. \n\n관리자에게 문의 바랍니다');
      }
      else {
        //var result = await RestApiProvider.to.putShopInfo(data);

        //
        final response2 = await DioClient().put(ServerInfo.REST_URL_SHOPINFO, data: data);

        if (response2.data['code'] != '00') {
          ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');

          // POS, 사장님 DB 원래대로 원복 ( 비밀번호 )
          shopChangePass.current = data['shopPass'];
          shopChangePass.password = data['current'];

          //await RestApiProvider.to.postShopChangePass(shopChangePass.toJson());

          await DioClient().post('https://ceo.daeguro.co.kr/Sync/MyPass', data: shopChangePass.toJson());
        }
      }
    }
  }

  Future<List<dynamic>> getImageHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qImageHistoryList = [];
    qImageHistoryList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPIMAGEHISTORY + '/$shopCode?page=$page&rows=$rows');

    if (response.data['code'] == '00') {
      qImageHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qImageHistoryList;
  }

  Future<dynamic> getCalcData(String shopCode) async {
    dynamic qDataCalcInfo;

    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPCALC + '/$shopCode?ucode=$ucode');

    if (response.data['code'] == '00') {
      qDataCalcInfo = response.data['data'];
    }
    else
      return null;

    return qDataCalcInfo;
  }

  Future<String> putCalcData(dynamic data, BuildContext context) async {
    //var result = await RestApiProvider.to.putShopCalc(data);

    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPCALC, data: data);

    
    

    if (response.data['code'] == '00') {
      return response.data['code'].toString();
    } else {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return response.data['code'].toString();
    }

    //getData();
  }

  postSetBankConfirm(String shopCode, String confirmYn, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPBANKCONFIRM + '/$shopCode?confirmYn=$confirmYn');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<String> postChargeJoin(String shopCode, String ucode, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPCHARGEJOIN + '/$shopCode?ucode=$ucode');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다\n\n - ' + response.data['msg'].toString());
      return response.data['code'].toString();
    }

    return response.data['code'].toString();
  }

  Future<List<dynamic>> getMenuGroupData(String shopCode) async {
    List<dynamic> qDataMenuGroup = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENUGROUP + '?shopCd=$shopCode');

    if (response.data['code'] == '00') {
      qDataMenuGroup.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuGroup;
  }

  Future<dynamic> getMenuGoupDetailData(String menuGroupCd) async {
    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENUGROUP + '/$menuGroupCd');

    if (response.data['code'] == '00') {
      qDataMenuGroupDetail = response.data['data'];
    }
    else
      return null;

    return qDataMenuGroupDetail;
  }

  postMenuGroupDetailData(String shopCode, dynamic data, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPMENUGROUP, data: data);

    
    


    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putMenuGroupDetailData(String shopCode, dynamic data, BuildContext context) async {
    //var result = await RestApiProvider.to.putShopMenuGroupDetail(data);

    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPMENUGROUP, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getMenuListData(String menuGroupCd) async {
    List<dynamic> qDataMenuList = [];

    qDataMenuList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENULIST + '/$menuGroupCd');

    if (response.data['code'] == '00') {
      qDataMenuList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuList;
  }

  putMenuCopyData(String menuCd, String uName, Map data, BuildContext context) async {
    //
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPMENUCOPY + '?menu_cd=$menuCd&insert_name=$uName');

    //
    //

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  updateMenuSort(String div, dynamic data, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPUPDATESORT + '?div=$div', data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getMenuDetailData(String menuCd) async {
    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENUDETAIL + '/$menuCd');

    if (response.data['code'] == '00') {
      qDataMenuDetail = response.data['data'];
    }
    else
      return null;

    return qDataMenuDetail;
  }

  postMenuDetailData(dynamic data, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPMENUDETAIL, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, response.data['msg']);
    }
  }

  putMenuDetailData(Map data, BuildContext context) async {
    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPMENUDETAIL, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, response.data['msg']);
    }
  }

  Future<List<dynamic>> getOptionGroupData(String shopCode, String menuCode) async {
    List<dynamic> qDataOptionGroupList = [];

    qDataOptionGroupList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '?shopCd=$shopCode&menuCd=$menuCode');

    if (response.data['code'] == '00') {
      qDataOptionGroupList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionGroupList;
  }

  Future<dynamic> getOptionGroupDetailData(String optionGroupCd) async {
    dynamic qDataOptionGroupDetail;

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '/$optionGroupCd');

    if (response.data['code'] == '00') {
      qDataOptionGroupDetail = response.data['data'];
    }
    else
      return null;

    return qDataOptionGroupDetail;
  }

  putOptionGroupDetailData(Map data, BuildContext context) async {
    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPOPTIONGROUP, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postOptionGroupDetailData(dynamic data, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPOPTIONGROUP, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteOptionGroupDetailData(String optionGroupCd, BuildContext context) async {
    
    final response = await DioClient().delete(ServerInfo.REST_URL_SHOPOPTIONGROUP + '/$optionGroupCd');

    
    
  }

  postCopyOptionGroupData(String shopCd, String optionGroupCd, String uName, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPCOPYOPTIONGROUP + '?shop_cd=$shopCd&option_group_cd=$optionGroupCd&insert_name=$uName');

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getOptionData(String optionGroupCd) async {
    List<dynamic> qDataOptionList = [];

    qDataOptionList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPOPTIONLIST + '/$optionGroupCd');

    if (response.data['code'] == '00') {
      qDataOptionList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataOptionList;
  }

  Future<dynamic> getOptionDetailData(String optionCd) async {
    dynamic qDataOptionDetail;

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPOPTIONDETAIL + '/$optionCd');

    if (response.data['code'] == '00') {
      qDataOptionDetail = response.data['data'];
    }
    else
      return null;

    return qDataOptionDetail;
  }

  postOptionDetailData(dynamic data, BuildContext context) async {
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPOPTIONDETAIL, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putOptionDetailData(Map data, BuildContext context) async {
    
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPOPTIONDETAIL, data: data);

    
    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteOptionDetailData(String optionCd, BuildContext context) async {
    
    final response = await DioClient().delete(ServerInfo.REST_URL_SHOPOPTIONDETAIL + '/$optionCd');

    
    
  }

  Future<List<dynamic>> getMenuOptionGroupData(String menuCode) async {
    List<dynamic> qDataMenuOptionGroupList = [];

    qDataMenuOptionGroupList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '/$menuCode');

    if (response.data['code'] == '00') {
      qDataMenuOptionGroupList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataMenuOptionGroupList;
  }

  postMenuOptionGroupData(String menuCode, dynamic data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '?menuCd=$menuCode', data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteMenuOptionGroupData(String menuOptionGroupCd, BuildContext context) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '/$menuOptionGroupCd');
  }

  Future<List<dynamic>> getMenuNameListData(String shopCode, String keyword) async {
    List<dynamic> tempRetData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPMENUNAMELIST + '?shopCd=$shopCode&keyword=$keyword');

    if (response.data['code'] == '00') {
      tempRetData.assignAll(response.data['data']);
    }
    else
      return null;

    return tempRetData;
  }

  Future<List<dynamic>> getShopNameListData(String mCode, String keyword) async {
    List<dynamic> tempRetData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPSHOPNAMELIST + '?mcode=$mCode&keyword=$keyword');

    if (response.data['code'] == '00') {
      tempRetData.assignAll(response.data['data']);
    }
    else
      return null;

    return tempRetData;
  }

  deleteRemoveMenuOptionData(String shopCode, BuildContext context) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_SHOPREMOVEMENUOPTION + '?shop_cd=$shopCode');
  }

  Future<String> postCopyMenuOptionData(String srcCcode, String srcShopCd, String destCcode, String destShopCd, String uName, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPCOPYMENUOPTION + '?source_cccode=$srcCcode&source_shop_cd=$srcShopCd&dest_cccode=$destCcode&dest_shop_cd=$destShopCd&insert_name=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return response.data['code'].toString();
    }

    return response.data['code'].toString();
  }

  putMenuComplete(String shopCd, String menuComplete, Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SHOPMENUCOMPLETE + '?shopCd=$shopCd&menuCompleteYn=$menuComplete');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getSectorData(String shopCode) async {
    List<dynamic> qDataSectorList = [];

    qDataSectorList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPSECTOR + '/$shopCode');

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

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPSECTORHIST + '/$shopCode?page=1&rows=100');

    if (response.data['code'] == '00') {
      qDataSectorList.assignAll(response.data['data']);
    } else
      return null;

    return qDataSectorList;
  }

  postSectorData(String shopCode, String sidoName, String gunguName, dynamic data, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];
    
    var response = await DioClient().post(ServerInfo.REST_URL_SHOPSECTOR + '?shopCd=$shopCode&sidoName=$sidoName&gunguName=$gunguName&ucode=$uCode&uname=$uName', data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getSectorGeofenceData(String shopCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_SHOPSECTOR_GETGEOFENCE + '/$shopCode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  postSectorGeofenceData(String shopCode, String yn, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var response = await DioClient().post(ServerInfo.REST_URL_SHOPSECTOR_SETGEOFENCE + '/$shopCode?yn=$yn&ucode=$uCode&uname=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> deleteSectorData(String shopCode, String sidoName, String gunguName) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];
    
    final response = await DioClient().delete(ServerInfo.REST_URL_SHOPSECTOR + '?shopCd=$shopCode&sidoName=$sidoName&gunguName=$gunguName&ucode=$uCode&uname=$uName');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<List<dynamic>> getSidoData() async {
    List<dynamic> qDataAddrSidoList = [];

    qDataAddrSidoList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_SIDO_CODE);

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

    final response = await DioClient().get(ServerInfo.REST_URL_GUNGU_CODE + '/$sido');

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

    final response = await DioClient().get(ServerInfo.REST_URL_DONG_CODE + '/$sido/$gungu');

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

    final response = await DioClient().get(ServerInfo.REST_URL_RI_CODE + '/$sido/$gungu/$dong');

    if (response.data['code'] == '00') {
      qDataAddrRiList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataAddrRiList;
  }

  Future<dynamic> getSaleTimeData(String shopCode) async {
    dynamic qDataSaleTime;

    final response = await DioClient().get(ServerInfo.REST_URL_SALETIME + '/$shopCode');

    if (response.data['code'] == '00') {
      qDataSaleTime = response.data['data'];
    }
    else
      return null;

    return qDataSaleTime;
  }

  Future<dynamic> postSaleTimeData(dynamic data) async {
    try{
      final response = await DioClient().post(ServerInfo.REST_URL_SET_SALETIME, data: data);

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
    final response = await DioClient().put(ServerInfo.REST_URL_SET_DAYTIME + '?shop_cd=$shopCode', data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getSaleDayTimeData(String shopCode, String tipGbn) async {
    List<dynamic> qDataSaleDayTimeList = [];

    qDataSaleDayTimeList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_DELITIP + '?shopCd=$shopCode&tipGbn=$tipGbn');

    if (response.data['code'] == '00') {
      qDataSaleDayTimeList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataSaleDayTimeList;
  }

  getDeliTipData(String shopCode, String tipGbn) async {
    final response = await DioClient().get(ServerInfo.REST_URL_DELITIP + '?shopCd=$shopCode&tipGbn=$tipGbn');

    if (response.data['code'] == '00') {
      if (tipGbn == '7') {
        qDataDeliTipTimeList.clear();
        qDataDeliTipTimeList.assignAll(response.data['data']);
      } else if (tipGbn == '3') {
        qDataDeliTipCostList.clear();
        qDataDeliTipCostList.assignAll(response.data['data']);
      } else if (tipGbn == '9') {
        qDataDeliTipLocalList.clear();
        qDataDeliTipLocalList.assignAll(response.data['data']);
      }
    }
  }

  Future<List<dynamic>> getDeliTipHistoryData(String shopCode, String page, String rows) async {
    List<dynamic> qDeliTipHistoryList = [];

    qDeliTipHistoryList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_DELITIPHISTORY + '/$shopCode?page=$page&rows=$rows');

    if (response.data['code'] == '00') {
      qDeliTipHistoryList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDeliTipHistoryList;
  }

  putDeliTipData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_DELITIP, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  postDeliTipData(dynamic data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_DELITIP, data: data);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  deleteDeliTipData(String tipSeq, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];
    
    final response = await DioClient().delete(ServerInfo.REST_URL_DELITIP + '/$tipSeq?modUcode=$uCode&modName=$uName');
  }

  Future<dynamic> setReserveShopInfoadmin(dynamic bodyData) async {
    try{
      final response = await DioClientReserve().post(ServerInfo.REST_RESERVEURL+'/shopInfo-admin', data: bodyData.toString());

      if (response.data['code'] != '00') {
        return response.data['msg'];
      }
      else
        return null;

    } catch (e){
      print('setReserveShopInfoadmin e:${e.toString()}');

      return e.toString();
    }
  }

  Future<List<dynamic>> getReserItems(String div) async {
    List<dynamic> itemsList = [];

    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/items-list?item=${div}');//('https://reser.daeguro.co.kr:10008/items');

    if (response.data['code'] == '00')
      itemsList = response.data['data'];
    else
      return null;

    return itemsList;
  }

  Future<dynamic> getReserShopInfo(String shopCode) async {
    dynamic qData;

    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/shopInfo?shopCd=$shopCode');//'https://reser.daeguro.co.kr:10008/shopInfo?shopCd=$shopCode');

    if (response.data['code'] == '00') {
        qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getReserShopThemeInfo(String shopCode) async {
    List<dynamic> qThemeData = [];

    final response = await DioClientReserve().get(ServerInfo.REST_RESERVEURL+'/shopInfo-tema?shopCd=$shopCode');//'https://reser.daeguro.co.kr:10008/shopInfo?shopCd=$shopCode');

    if (response.data['code'] == '00') {
      qThemeData.assignAll(response.data['data']);
    }
    else
      return null;

    return qThemeData;
  }

  Future<dynamic> setReserShopThemeInfo(dynamic bodyData, BuildContext context) async {
    try{
      //print('bodyData:${bodyData.toString()}');
      final response = await DioClientReserve().put(ServerInfo.REST_RESERVEURL+'/shopInfo-tema', data: bodyData.toString());//'https://reser.daeguro.co.kr:10008/shopInfo?shopCd=$shopCode');

      if (response.data['code'] != '00') {
        ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else
        return null;

    }catch (e){
      print('setReserShopThemeInfo e:${e.toString()}');
    }
  }

  Future<List<dynamic>> getImageData(String shopCode) async {
    List<dynamic> qDataImageList = [];

    qDataImageList.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_IMAGE + '?shop_cd=$shopCode');

    if (response.data['code'] == '00') {
      qDataImageList.assignAll(response.data['data']);
    }
    else
      return null;

    return qDataImageList;
  }

  putMenuImageRemove(BuildContext context, String menuCode, String ccCode, String shopCode) async {
    final response = await DioClient().put(ServerInfo.REST_URL_MENUIMAGE_REMOVE + '?menu_cd=$menuCode&cccode=$ccCode&shop_cd=$shopCode');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 처리 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List> getDataBankItems() async {
    List qDataBankItems = [];

    qDataBankItems.clear();

    final response = await DioClient().get(ServerInfo.REST_URL_BANK_CODE);

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

    final response = await DioClient().get(ServerInfo.REST_URL_DIV_CODE);

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
    
    final response = await DioClient().put(ServerInfo.REST_URL_IMAGE + '/removeShopImage/$cccode/$shop_cd?&salesmanCode=$uCode&salesmanName=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putUpdateImageStatus(String shop_cd, String status, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SHOP + '/updateImageStatus?shop_cd=$shop_cd&status=$status');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 상태변경이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putUpdateShopStatus(String shop_cd, String status, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_SHOP + '/updateShopStatus?shop_cd=$shop_cd&status=$status&mod_ucode=$uCode&mod_name=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 상태변경이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getShopOrderCancelListData(String posYn, String gungu, String startDate, String endDate, String _page, String _raw) async {
    List<dynamic> qData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_SHOPORDERCANCELLIST + '?pos_yn=$posYn&gungu=$gungu&date_begin=$startDate&date_end=$endDate&page=$_page&rows=$_raw');

    if (result.data['code'] == '00') {
      total_count = int.parse(result.data['totalCount'].toString());
      totalRowCnt = int.parse(result.data['count'].toString());

      qData.assignAll(result.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getshopeventlist(String mCode, String shopName, String state, String date_begin, String date_end, String _page, String _raw) async {
    List<dynamic> qData = [];

    date_begin = date_begin.toString().replaceAll('-', '');
    date_end = date_end.toString().replaceAll('-', '');

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPEVENTLIST + '?mCode=$mCode&shopName=$shopName&state=$state&date_begin=$date_begin&date_end=$date_end&page=$_page&rows=$_raw');

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

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPEVENTHIST + '/$shopCode?page=$page&rows=$rows');

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

    final response = await DioClient().get(ServerInfo.REST_URL_SHOPEVENTMENU + '/$shopCode?state=$state&page=$page&rows=$rows');

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
    
    final response = await DioClient().put(ServerInfo.REST_URL_MOVEREVIEW + '?from_shop_cd=$fromShopCode&to_shop_cd=$toShopCode&ucode=$ucode&uname=$uname');

    await DioClient().postRestLog('0', '/ShopReview/moveReview',
        '[리뷰 이관 요청] fromShopCode : $fromShopCode, toShopCode : $toShopCode, ucode : $ucode, uname : $uname || return : [' + response.data['code'] + '] ' + response.data['msg']);

    // print('===== putMoveReview()-> '+ result.bodyString.toString());

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 처리되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<String> getEventYn(String shopCd) async {
    final response = await DioClient().get(ServerInfo.REST_URL_SHOPEVENTYN + '/$shopCd');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<String> putShopContractEnd(BuildContext context, String shopCd, String date_end_contract) async {    
    final response = await DioClient().put(ServerInfo.REST_URL_CONTRACTEND+'/$shopCd?date_end_contract=$date_end_contract');    

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다\n\n - ' + response.data['msg'].toString());
      return response.data['code'].toString();
    }

    return response.data['code'].toString();
  }

  Future<List<dynamic>> getReserListData(String shopCd, String dateBegin, String dateEnd, String status, String jobGbn, String searchInfo, String page, String pageRows) async {
    List<dynamic> qData = [];

    final result = await DioClientReserve().get(ServerInfo.REST_RESERVEURL + '/reser-list'+
            '/$status?shopCd=$shopCd&dateBegin=$dateBegin&dateEnd=$dateEnd&jobGbn=$jobGbn&searchInfo=$searchInfo&page=$page&pageRows=$pageRows');

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
    final response = await DioClient().get(ServerInfo.REST_URL_DBREGCHECK + '?mcode=$mcode&reg_no=$buss_reg_no');

    //if (response.data['code'] != '00') {
    return response.data['data'];
    //}
  }

  Future<dynamic> postPosShopUpdate(String url, dynamic data) async {
    final response = await DioClientPos().post(url, data);
    //print('response:${response.toString()}');
    return response;
  }

  Future<List<dynamic>> getShopReserveImage(String shopCode, BuildContext context) async {
    List<dynamic> shopInfoImageList = [];

    shopInfoImageList.clear();

    final response = await DioClientReserve().get(ServerInfo.REST_URL_SHOPRESERVE_IMAGE + '/$shopCode');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 조회 되지 않았습니다. \n\n- [${response.data['code']}] ${response.data['msg']}');
    }
    else{
      shopInfoImageList.assignAll(response.data['data']);
    }

    return shopInfoImageList;
  }

  deleteShopInfoImage(String ccCode, String shopCd, String seq, BuildContext context) async {
    final response = await DioClientReserve().deleteImage(ServerInfo.REST_URL_SHOPRESERVE_IMAGE_DELETE, ccCode , shopCd, seq);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getDelitipDaeguro(String shopCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_DELITIPDAEGURO + '/$shopCode');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }

    return null;
  }

  Future<List<dynamic>> getShopReserveReviewImage(String shopCode) async {
    List<dynamic> qData = [];

    final response = await DioClientReserve().get(ServerInfo.REST_URL_SHOP_RESERVE_REVIEW_IMAGE + '/$shopCode');

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  deleteShopReserveReviewImage(String ccCode, String shopCd, String seq, BuildContext context) async {
    final response = await DioClientReserve().deleteReviewImage(ServerInfo.REST_URL_SHOP_RESERVE_REVIEW_IMAGE_DELETE, ccCode, shopCd, seq);

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 삭제 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<String> postDelitipDaeguro(String shopCode, String yn, String deli_dgr_amt, BuildContext context) async {
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    var response = await DioClient().post(ServerInfo.REST_URL_SET_DELITIPDAEGURO + '/$shopCode?yn=$yn&deli_dgr_amt=$deli_dgr_amt&ucode=$uCode&uname=$uName');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다\n\n - ' + response.data['msg'].toString());
      return response.data['code'].toString();
    }

    return response.data['code'].toString();
  }


}
