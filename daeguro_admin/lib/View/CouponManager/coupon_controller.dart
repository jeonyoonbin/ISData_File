import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CouponController extends GetxController with SingleGetTickerProviderMixin {
  static CouponController get to => Get.find();
  BuildContext context;

  List<dynamic> qDataDetail = [];

  int totalRowCnt = 0;
  int pub = 0;
  int giv = 0;
  int use = 0;
  int del = 0;
  int exp = 0;

  String totalHistoryCnt = '0';
  String totalB2BHistoryCnt = '0';

  RxString divKey = ''.obs;
  RxString keyword = ''.obs;
  RxInt raw = 0.obs;
  RxInt page = 0.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    raw.value = 15;
    page.value = 1;

    super.onInit();
  }

  Future<List<dynamic>> getData(BuildContext context, String couponType, String couponStatus) async {

    pub = 0;
    giv = 0;
    use = 0;
    del = 0;
    exp = 0;

    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_COUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=${keyword.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      pub = int.parse(result.data['pub'].toString());
      giv = int.parse(result.data['giv'].toString());
      use = int.parse(result.data['use'].toString());
      del = int.parse(result.data['del'].toString());
      exp = int.parse(result.data['exp'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<List> getDataCodeItems(BuildContext context) async {
    List qDataItems = [];

    final result = await DioClient().get(ServerInfo.REST_URL_COUPON_CODE_R);

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  postData(dynamic data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_COUPON + '?couponType=${data["couponType"]}&couponCount=${data["couponCount"]}&isdAmt=${data["isdAmt"]}&exp_date=${data["exp_date"]}&insertUcode=${data["insertUcode"]}&insertName=${data["insertName"]}');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_COUPON + '?couponType=${data["couponType"]}&couponCount=${data["couponCount"]}&oldStatus=${data["oldStatus"]}&newStatus=${data["newStatus"]}&jobUcode=${data["jobUcode"]}&jobName=${data["jobName"]}');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getHistoryData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_COUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  putsetCouponAppCustomer(String jobGbn, String custCode, String couponType, String newStatus, BuildContext context) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_SETCOUPONAPPCUSTOMER + '?jobGbn=$jobGbn&custCode=$custCode&couponType=$couponType&newStatus=$newStatus&ucode=$ucode');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n' + response.data['msg'].toString());
    }
  }

  putsetCouponAppCustomerDisposal(String jobGbn, String custCode, String couponType, String newStatus, String couponNo, String orderNo, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_SETCOUPONAPPCUSTOMER + '?jobGbn=$jobGbn&custCode=$custCode&couponType=$couponType&newStatus=$newStatus&couponNo=$couponNo&orderNo=$orderNo');

    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    await DioClient().postRestLog('0', '/Coupon/setCouponAppCustomer',
        '[쿠폰 폐기] custCode : $custCode, couponType : $couponType, couponNo : $couponNo, ins_ucode : $ucode, ins_name : $name || return : [' + response.data['code'] + '] ' + response.data['msg']);

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n관리자에게 문의 바랍니다');
    }
  }


  // B2B쿠폰 ////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getB2BData(BuildContext context, String couponType, String couponStatus) async {
    List<dynamic> retData = [];

    pub = 0;
    giv = 0;
    use = 0;
    del = 0;
    exp = 0;

    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=${keyword.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      pub = int.parse(result.data['pub'].toString());
      giv = int.parse(result.data['giv'].toString());
      use = int.parse(result.data['use'].toString());
      del = int.parse(result.data['del'].toString());
      exp = int.parse(result.data['exp'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<dynamic> getB2BDetailCoupon(String couponNo) async {
    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON + '/$couponNo');

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;

  }

  Future<List> getDataB2BCodeItems(BuildContext context) async {
    List retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON_CODE);

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List> getDataB2BItems(String coupon_type) async {
    List retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON_ITEMCODE + '?couponType=$coupon_type');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  postB2BData(Map data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_B2BCOUPON + '?couponType=${data["couponType"]}&itemType=${data["itemType"]}&expDate=${data["expDate"]}&couponCount=${data["couponCount"]}&insertUcode=${data["insertUcode"]}&insertName=${data["insertName"]}&title=${data["title"]}');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putB2BData(Map data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_B2BCOUPON + '?couponType=${data["couponType"]}&itemType=${data["itemType"]}&couponCount=${data["couponCount"]}&oldStatus=${data["oldStatus"]}&newStatus=${data["newStatus"]}&jobUcode=${data["jobUcode"]}&jobName=${data["jobName"]}');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getB2BChangeData(String couponNo) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON_CHANGE + '/$couponNo');

    if (result.data['code'] == '00') {
      totalB2BHistoryCnt = result.data['totalCount'].toString();
      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getB2BHistoryData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BCOUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  putB2BsetCouponAppCustomer(String custCode, String couponType, String couponNo, String status, BuildContext context) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_B2BSETCOUPONAPPCUSTOMER + '?modUcode=$ucode&custCode=$custCode&couponType=$couponType&couponNo=$couponNo&status=$status');

    await DioClient().postRestLog('0', '/B2BCoupon/setCouponAppCustomer',
        '[제휴 쿠폰 폐기] couponType : $couponType, status : $status, ins_ucode : $ucode, ins_name : $name || return : [' + response.data['code'] + '] ' + response.data['msg'] + ' || couponNo : ' + response.data['couponNo']);

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n' + response.data['msg'].toString());
    }
  }

  Future<List<dynamic>> getB2BUserData(String divKey, String keyword) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BUSERCOUPON + '?divKey=$divKey&keyword=$keyword&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<dynamic> getB2BUserDetailCoupon(String userId) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final result = await DioClient().get(ServerInfo.REST_URL_B2BUSERCOUPONDETAIL + '/$userId?ucode=$ucode');

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;
  }

  Future<dynamic> postB2BUserData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    var response = await DioClient().post(ServerInfo.REST_URL_B2BUSERCOUPON + '?name=${data["NAME"]}&loginId=${data["LOGIN_ID"]}&loginPwd=${data["LOGIN_PWD"]}&mobile=${data["MOBILE"]}&couponType=${data["COUPON_TYPE"]}&ucode=$ucode');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putB2BUserData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().put(ServerInfo.REST_URL_B2BUSERCOUPONSET + '?userId=${data["USER_ID"].toString()}&couponType=${data["COUPON_TYPE"].toString()}&name=${data["NAME"].toString()}&loginId=${data["LOGIN_ID"].toString()}&loginPwd=${data["LOGIN_PWD"].toString()}&mobile=${data["MOBILE"].toString()}&useYn=${data["USE_YN"].toString()}&modUcode=${ucode}');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    } else
      return;
  }

  Future<List> getBrandListItems() async {
    List retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_GETBRANDLIST);

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List> getBrandCouponListItems(String chainCode) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_GETBRANDCOUPONLIST + '?chainCode=$chainCode');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getBrandCouponShopData(String chainCode, String couponType, String page, String rows) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_GETBRANDCOUPONSHOP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows');

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  putBrandCouponShop(String couponType, String useYn, String useMaxCount, String modUcode, String modName, List data, BuildContext context) async {
    final response = await DioClient().put(ServerInfo.REST_URL_GETBRANDCOUPONSHOP + '?couponType=$couponType&useYn=$useYn&useMaxCount=$useMaxCount&modUcode=$modUcode&modName=$modName', data: data);

    await DioClient().postRestLog('0', '/ChainCouponShop',
        '[브랜드 쿠폰 변경] couponType : ' + couponType + ', useYn :' + useYn + ', useMaxCount :' + useMaxCount + ', modUcode :' + modUcode + ', modName :' + modName + ', shop_cd : ' + data.toString() +
            ' [[ ret_code : ' + response.data['code'] + ', ret_msg : ' + response.data['msg'] + ' ]]');

    if (response.data['code'] != '00') {
      ISAlert(context, '저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getBrandData(String chainCode, String couponType, String status) async {
    List<dynamic> qData = [];

    pub = 0;
    giv = 0;
    use = 0;
    del = 0;
    exp = 0;

    final response = await DioClient().get(ServerInfo.REST_URL_BRANDCOUPON + '?chainCode=$chainCode&couponType=$couponType&status=$status&keyword=${keyword.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (response.data['code'] == '00') {
      totalRowCnt = int.parse(response.data['count'].toString());
      pub = int.parse(response.data['pub'].toString());
      giv = int.parse(response.data['giv'].toString());
      use = int.parse(response.data['use'].toString());
      del = int.parse(response.data['del'].toString());
      exp = int.parse(response.data['exp'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getBrandDetailCoupon(String couponNo) async {
    final response = await DioClient().get(ServerInfo.REST_URL_BRANDCOUPON + '/$couponNo');

    if (response.data['code'] == '00') {
      return response.data['data'];
    }
    else
      return null;
  }

  postBrandData(Map data, BuildContext context) async {
    var response = await DioClient().post(ServerInfo.REST_URL_BRANDCOUPON + '?couponType=${data["couponType"]}&couponCount=${data["couponCount"]}&chainCode=${data["chainCode"]}&startDate=${data["startDate"]}&endDate=${data["endDate"]}&isdAmt=${data["isdAmt"]}&insertUcode=${data["insertUcode"]}&insertName=${data["insertName"]}');

    if (response.data['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> putBrandData(Map data) async {
    final response = await DioClient().put(ServerInfo.REST_URL_BRANDCOUPON + '?couponType=${data["couponType"]}&couponCount=${data["couponCount"]}&oldStatus=${data["oldStatus"]}&newStatus=${data["newStatus"]}&jobUcode=${data["jobUcode"]}&jobName=${data["jobName"]}');

    if (response.data['code'] != '00') {
      return response.data['msg'].toString();
    }
    else
      return null;
  }

  Future<dynamic> putBrandsetCouponAppCustomer(String custCode, String couponType, String couponNo, String status) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_BRANDSETCOUPONAPPCUSTOMER + '?modUcode=$ucode&custCode=$custCode&couponType=$couponType&couponNo=$couponNo&status=$status');

    await DioClient().postRestLog('0', '/ChainCoupon/setCouponAppCustomer',
        '[제휴 쿠폰 폐기] couponType : $couponType, status : $status, ins_ucode : $ucode, ins_name : $name || return : [' + response.data['code'] + '] ' + response.data['msg']);

    if (response.data['code'] != '00') {
      return response.data['msg'].toString();
    }
    else
      return null;
  }

  Future<List<dynamic>> getBrandHistoryData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_BRANDCOUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    if (result.data['code'] == '00') {
      totalHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getBrandChangeData(String couponNo) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_BRANDCOUPON_CHANGE + '/$couponNo');

    if (result.data['code'] == '00') {
      totalB2BHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }


  Future<List<dynamic>> getBrandCouponAppData(String chainCode, String couponType, String page, String rows) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows');

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<dynamic> postBrandCouponAppData(Map data) async {
    var response = await DioClient().post(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=${data["COUPON_TYPE"]}&chainCode=${data["CHAIN_CODE"]}&orderMinAmt=${data["ORDER_MIN_AMT"]}&payMinAmt=${data["PAY_MIN_AMT"]}&deliveryYn=${data["DELIVERY_YN"]}&packYn=${data["PACK_YN"]}&displayStDate=${data["DISPLAY_ST_DATE"]}&displayExpDate=${data["DISPLAY_EXP_DATE"]}&insertUcode=${data["INS_UCODE"]}&insertName=${data["INS_NAME"]}&useYn=${data["USE_YN"]}');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putBrandCouponAppData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String uname = GetStorage().read('logininfo')['name'];

    final response = await DioClient().put(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=${data["COUPON_TYPE"].toString()}&orderMinAmt=${data["ORDER_MIN_AMT"].toString()}&payMinAmt=${data["PAY_MIN_AMT"].toString()}&deliveryYn=${data["DELIVERY_YN"].toString()}&packYn=${data["PACK_YN"].toString()}&displayStDate=${data["DISPLAY_ST_DATE"].toString()}&displayExpDate=${data["DISPLAY_EXP_DATE"].toString()}&modUcode=${ucode}&modeName=${uname}&useYn=${data["USE_YN"].toString()}');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    } else
      return;
  }

  deleteBrandCouponAppData(BuildContext context, String couponType) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=$couponType');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> getBrandCouponAppDetail(String couponType) async {
    final result = await DioClient().get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '/$couponType');

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;
  }
}
