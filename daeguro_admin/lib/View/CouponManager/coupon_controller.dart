import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CouponController extends GetxController with SingleGetTickerProviderMixin {
  static CouponController get to => Get.find();
  BuildContext context;

  //List<dynamic> qData = [];
  List<dynamic> qDataDetail = [];

  //List<dynamic> qB2BData = [];
  //List<dynamic> qB2BDataDetail = [];


  //List qB2BDataItems = [];
  //List qB2BCodeItems = [];

  //List qBrandListItems = [];
  //List qBrandCouponListItems = [];

  int totalRowCnt = 0;
  int pub = 0;
  int giv = 0;
  int use = 0;
  int del = 0;
  int exp = 0;

  String totalHistoryCnt = '0';
  String totalB2BHistoryCnt = '0';

  // RxString couponType = 'IS_C100'.obs;
  // RxString couponB2BType = 'B2B_C100'.obs;
  // RxString couponStatus = '00'.obs;
  // RxString couponB2BStatus = '00'.obs;
  RxString divKey = ''.obs;
  RxString keyword = ''.obs;
  RxInt raw = 0.obs;
  RxInt page = 0.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    raw.value = 15;
    page.value = 1;

    //getData(context);

    super.onInit();
  }

  Future<List<dynamic>> getData(BuildContext context, String couponType, String couponStatus) async {
    // List<dynamic> qData = [];
    //
    pub = 0;
    giv = 0;
    use = 0;
    del = 0;
    exp = 0;

    //
    // var result = await RestApiProvider.to.getCoupon(couponType, couponStatus, keyword.value, page.value, raw.value);
    //
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // pub = int.parse(result.body['pub'].toString());
    // giv = int.parse(result.body['giv'].toString());
    // use = int.parse(result.body['use'].toString());
    // del = int.parse(result.body['del'].toString());
    //
    // qData.assignAll(result.body['data']);
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;


    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_COUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=${keyword.value}&page=${page.value}&rows=${raw.value}');

    dio.clear();
    dio.close();

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
    // var result = await RestApiProvider.to.getCouponCode();
    //
    // qDataItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }



    List qDataItems = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_COUPON_CODE);

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  postData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postCoupon(data["couponType"], data["couponCount"], data["isdAmt"], data["insertUcode"], data["insertName"]);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.putCoupon(data["couponType"], data["couponCount"], data["oldStatus"], data["newStatus"], data["jobUcode"], data["jobName"]);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getHistoryData() async {
    // List<dynamic> qHistoryData = [];
    //
    // var result = await RestApiProvider.to.getHistoryCoupon(fromDate.value.toString(), toDate.value.toString(), page.value.toString(), raw.value.toString());
    //
    // if (result.body['code'] == '00') {
    //   totalHistoryCnt = result.body['totalCount'].toString();
    //
    //   qHistoryData.assignAll(result.body['data']);
    // } else
    //   return null;
    //
    // return qHistoryData;

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_COUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

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

    var result = await RestApiProvider.to.putSetCouponAppCustomer(jobGbn, custCode, couponType, newStatus, ucode);

    // await RestApiProvider.to.postRestError('0', '/admin/Coupon : putsetCouponAppCustomer',
    //     '[쿠폰 발급] custCode : $custCode, couponType : $couponType, ins_ucode : $ucode, ins_name : $name || return : [' + result.body['code'] + '] ' + result.body['msg'] + ' || couponNo : ' + result.body['couponNo']);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n' + result.body['msg'].toString());
    }
  }

  putsetCouponAppCustomerDisposal(String jobGbn, String custCode, String couponType, String newStatus, String couponNo, String orderNo, BuildContext context) async {
    var result = await RestApiProvider.to.putSetCouponAppCustomerDisposal(jobGbn, custCode, couponType, newStatus, couponNo, orderNo);

    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    await RestApiProvider.to.postRestError('0', '/admin/Coupon : putSetCouponAppCustomer',
        '[쿠폰 폐기] custCode : $custCode, couponType : $couponType, couponNo : $couponNo, ins_ucode : $ucode, ins_name : $name || return : [' + result.body['code'] + '] ' + result.body['msg']);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n관리자에게 문의 바랍니다');
    }
  }


  // B2B쿠폰 ////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getB2BData(BuildContext context, String couponType, String couponStatus) async {
    // List<dynamic> qData = [];
    //
    // pub = 0;
    // giv = 0;
    // use = 0;
    // del = 0;
    //
    // var result = await RestApiProvider.to.getB2BCoupon(couponType, couponStatus, keyword.value, page.value, raw.value);
    //
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // pub = int.parse(result.body['pub'].toString());
    // giv = int.parse(result.body['giv'].toString());
    // use = int.parse(result.body['use'].toString());
    // del = int.parse(result.body['del'].toString());
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;

    //

    List<dynamic> retData = [];

    pub = 0;
    giv = 0;
    use = 0;
    del = 0;
    exp = 0;

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=${keyword.value}&page=${page.value}&rows=${raw.value}');

    dio.clear();
    dio.close();

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
    // var result = await RestApiProvider.to.getB2BDetailCoupon(couponNo);
    //
    // if (result.body['code'] == '00')
    //   return result.body['data'];
    // else
    //   return null;

    //

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON + '/$couponNo');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;

  }

  Future<List> getDataB2BCodeItems(BuildContext context) async {
    // var result = await RestApiProvider.to.getB2BCouponCode();
    //
    // qB2BDataItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }

    //

    List retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON_CODE);

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List> getDataB2BItems(String coupon_type) async {
    // var result = await RestApiProvider.to.getB2BCouponItemCode(coupon_type);
    //
    // qB2BCodeItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }

    //

    List retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON_ITEMCODE + '?couponType=$coupon_type');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  postB2BData(Map data, BuildContext context) async {
    //print('postB2BData -> couponType:${data["couponType"]}, couponCount:${data["couponCount"]}, startDate:${data["startDate"]}');
    var result = await RestApiProvider.to.postB2BCoupon(data["couponType"], data["itemType"], data["couponCount"], data["insertUcode"], data["insertName"], data["title"]);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  putB2BData(Map data, BuildContext context) async {
    //print('putB2BData -> couponType:${data["couponType"]}, couponCount:${data["couponCount"]}, oldStatus:${data["oldStatus"]}, newStatus:${data["newStatus"]}, jobUcode:${data["jobUcode"]}, jobName:${data["jobName"]}');

    var result = await RestApiProvider.to.putB2BCoupon(data["couponType"], data["itemType"], data["couponCount"], data["oldStatus"], data["newStatus"], data["jobUcode"], data["jobName"]);

    print(result);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<List<dynamic>> getB2BChangeData(String couponNo) async {
    // List<dynamic> qHistoryData = [];
    //
    // var result = await RestApiProvider.to.getB2BChangeCoupon(couponNo);
    //
    // //print('getB2BHistoryData-> ${result.bodyString}');
    //
    // if (result.body['code'] == '00') {
    //   totalB2BHistoryCnt = result.body['totalCount'].toString();
    //
    //   qHistoryData.assignAll(result.body['data']);
    // } else
    //   return null;
    //
    // return qHistoryData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON_CHANGE + '/$couponNo');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00') {
      totalB2BHistoryCnt = result.data['totalCount'].toString();
      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getB2BHistoryData() async {
    // List<dynamic> qHistoryData = [];
    //
    // var result = await RestApiProvider.to.getB2BHistoryCoupon(fromDate.value.toString(), toDate.value.toString(), page.value.toString(), raw.value.toString());
    //
    // if (result.body['code'] == '00') {
    //   totalHistoryCnt = result.body['totalCount'].toString();
    //
    //   qHistoryData.assignAll(result.body['data']);
    // } else
    //   return null;
    //
    // return qHistoryData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BCOUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

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

    //print('putB2BsetCouponAppCustomer-> custCode: ${custCode}, couponType: ${couponType}, couponNo: ${couponNo}, status: ${status}');

    var result = await RestApiProvider.to.putB2BSetCouponAppCustomer(ucode, custCode, couponType, couponNo, status);

    await RestApiProvider.to.postRestError('0', '/admin/B2BCoupon : putsetCouponAppCustomer',
        '[제휴 쿠폰 폐기] couponType : $couponType, status : $status, ins_ucode : $ucode, ins_name : $name || return : [' + result.body['code'] + '] ' + result.body['msg'] + ' || couponNo : ' + result.body['couponNo']);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 상태변경 실패 \n\n' + result.body['msg'].toString());
    }
  }

  Future<List<dynamic>> getB2BUserData(String divKey, String keyword) async {
    // List<dynamic> qData = [];
    //
    // var result = await RestApiProvider.to.getB2BUserCoupon(divKey, keyword, page.value, raw.value);
    //
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // if (result.body['code'] == '00')
    //   qData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return qData;



    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BUSERCOUPON + '?divKey=$divKey&keyword=$keyword&page=${page.value}&rows=${raw.value}');

    dio.clear();
    dio.close();

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
    //
    // var result = await RestApiProvider.to.getB2BUserCouponDetail(userId, ucode);
    //
    // if (result.body['code'] == '00') {
    //   return result.body['data'];
    // } else
    //   return null;

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_B2BUSERCOUPONDETAIL + '/$userId?ucode=$ucode');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;
  }

  Future<dynamic> postB2BUserData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    var result = await RestApiProvider.to.postB2BUserCoupon(data["NAME"], data["LOGIN_ID"], data["LOGIN_PWD"], data["MOBILE"], data["COUPON_TYPE"], ucode);

    //print('postB2BUserData-> ${result.bodyString}');

    if (result.body['code'] != '00') {
      //ISAlert(context, '회원 등록이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['msg'];
    } else
      return null;
  }

  Future<dynamic> putB2BUserData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    var result = await RestApiProvider.to.putB2BUserCoupon(data["USER_ID"].toString(), data["COUPON_TYPE"].toString(), data["NAME"].toString(),
        data["LOGIN_ID"].toString(), data["LOGIN_PWD"].toString(), data["MOBILE"].toString(), data["USE_YN"].toString(), ucode);

    if (result.body['code'] != '00') {
      //ISAlert(context, '회원 정보 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['msg'];
    } else
      return;
  }

  Future<List> getBrandListItems() async {
    // qBrandListItems.clear();
    //
    // var result = await RestApiProvider.to.getBrandList();
    //
    // qBrandListItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '브랜 정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }
    //
    // return result.body['data'];

    List retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_GETBRANDLIST);

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List> getBrandCouponListItems(String chainCode) async {
    // qBrandCouponListItems.clear();
    //
    // var result = await RestApiProvider.to.getBrandCouponList(chainCode);
    //
    // qBrandCouponListItems.assignAll(result.body['data']);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '브랜드 쿠폰 정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
    // }
    //
    // return result.body['data'];

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_GETBRANDCOUPONLIST + '?chainCode=$chainCode');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getBrandCouponShopData(String chainCode, String couponType, String page, String rows) async {
    // List<dynamic> qData = [];
    //
    // var result = await RestApiProvider.to.getBrandCouponShopList(chainCode, couponType, page, rows);
    //
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // //print('getChainCouponShopData -> ${result.bodyString}');
    //
    // if (result.body['code'] == '00') {
    //   qData.assignAll(result.body['data']);
    //   return qData;
    // }
    // else
    //   return null;

    //
    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_GETBRANDCOUPONSHOP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  putBrandCouponShop(String couponType, String useYn, String useMaxCount, String modUcode, String modName, List data, BuildContext context) async {
    var result = await RestApiProvider.to.putBrandCouponShop(couponType, useYn, useMaxCount, modUcode, modName, data);

    await RestApiProvider.to.postRestError('0', '/admin/ChainCouponShop : putChainCouponShop',
        '[브랜드 쿠폰 변경] couponType : ' + couponType + ', useYn :' + useYn + ', useMaxCount :' + useMaxCount + ', modUcode :' + modUcode + ', modName :' + modName + ', shop_cd : ' + data.toString() +
            ' [[ ret_code : ' + result.body['code'] + ', ret_msg : ' + result.body['msg'] + ' ]]');

    if (result.body['code'] != '00') {
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

    var result = await RestApiProvider.to.getBrandCoupon(chainCode, couponType, status, keyword.value, page.value, raw.value);

    //print('getChainCouponShopData -> ${result.bodyString}');

    totalRowCnt = int.parse(result.body['count'].toString());

    pub = int.parse(result.body['pub'].toString());
    giv = int.parse(result.body['giv'].toString());
    use = int.parse(result.body['use'].toString());
    del = int.parse(result.body['del'].toString());
    exp = int.parse(result.body['exp'].toString());

    if (result.body['code'] == '00')
      qData.assignAll(result.body['data']);
    else
      return null;

    return qData;
  }

  Future<dynamic> getBrandDetailCoupon(String couponNo) async {
    var result = await RestApiProvider.to.getBrandDetailCoupon(couponNo);

    if (result.body['code'] == '00')
      return result.body['data'];
    else
      return null;
  }

  postBrandData(Map data, BuildContext context) async {
    var result = await RestApiProvider.to.postBrandCoupon(data["couponType"], data["couponCount"], data["chainCode"], data["startDate"], data["endDate"], data["isdAmt"], data["insertUcode"], data["insertName"]);

    if (result.body['code'] != '00') {
      ISAlert(context, '쿠폰 발행이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> putBrandData(Map data) async {
    //print('putBrandData -> ${data["couponType"]}, ${data["couponCount"]}, ${data["oldStatus"]}, ${data["newStatus"]}, ${data["jobUcode"]}, ${data["jobName"]}');

    var result = await RestApiProvider.to.putBrandCoupon(data["couponType"], data["couponCount"], data["oldStatus"], data["newStatus"], data["jobUcode"], data["jobName"]);

    //print('putBrandData-> ${result.bodyString}');

    if (result.body['code'] != '00') {
      //ISAlert(context, 'test');
      //ISAlert(context, '쿠폰 변경 실패 \n\n' + result.body['msg'].toString());
      return result.body['msg'].toString();
    }
    else
      return null;
  }

  Future<dynamic> putBrandsetCouponAppCustomer(String custCode, String couponType, String couponNo, String status) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String name = GetStorage().read('logininfo')['name'];

    //print('putBrandsetCouponAppCustomer-> custCode: ${custCode}, couponType: ${couponType}, couponNo: ${couponNo}, status: ${status}');

    var result = await RestApiProvider.to.putBrandSetCouponAppCustomer(ucode, custCode, couponType, couponNo, status);

    //print('putBrandsetCouponAppCustomer-> ${result.bodyString}');

    await RestApiProvider.to.postRestError('0', '/admin/ChainCoupon : putsetCouponAppCustomer',
        '[제휴 쿠폰 폐기] couponType : $couponType, status : $status, ins_ucode : $ucode, ins_name : $name || return : [' + result.body['code'] + '] ' + result.body['msg']);

    if (result.body['code'] != '00') {
      //ISAlert(context, '쿠폰 상태변경 실패 \n\n' + result.body['msg'].toString());
      return result.body['msg'].toString();
    }
    else
      return null;
  }

  Future<List<dynamic>> getBrandHistoryData() async {
    // List<dynamic> qHistoryData = [];
    //
    // var result = await RestApiProvider.to.getBrandHistoryCoupon(fromDate.value.toString(), toDate.value.toString(), page.value.toString(), raw.value.toString());
    //
    // if (result.body['code'] == '00') {
    //   totalHistoryCnt = result.body['totalCount'].toString();
    //
    //   qHistoryData.assignAll(result.body['data']);
    // } else
    //   return null;
    //
    // return qHistoryData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_BRANDCOUPON_HISTORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}&page=${page.value.toString()}&rows=${raw.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00') {
      totalHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getBrandChangeData(String couponNo) async {
    // List<dynamic> qHistoryData = [];
    //
    // var result = await RestApiProvider.to.getBrandChangeCoupon(couponNo);
    //
    // //print('getB2BHistoryData-> ${result.bodyString}');
    //
    // if (result.body['code'] == '00') {
    //   totalB2BHistoryCnt = result.body['totalCount'].toString();
    //
    //   qHistoryData.assignAll(result.body['data']);
    // } else
    //   return null;
    //
    // return qHistoryData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_BRANDCOUPON_CHANGE + '/$couponNo');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00') {
      totalB2BHistoryCnt = result.data['totalCount'].toString();

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }


  Future<List<dynamic>> getBrandCouponAppData(String chainCode, String couponType, String page, String rows) async {
    // List<dynamic> qData = [];
    //
    // //print('getChainCouponShopData -> mcode:${mcode}, chainCode:${chainCode}, couponType:${couponType}, page:${page}, rows:${rows}');
    //
    // var result = await RestApiProvider.to.getBrandCouponAppList(chainCode, couponType, page, rows);
    //
    // totalRowCnt = int.parse(result.body['count'].toString());
    //
    // //print('getChainCouponShopData -> ${result.bodyString}');
    //
    // if (result.body['code'] == '00') {
    //   qData.assignAll(result.body['data']);
    //   return qData;
    // }
    // else
    //   return null;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00') {
      totalRowCnt = int.parse(result.data['count'].toString());

      retData.assignAll(result.data['data']);
    }
    else
      return null;

    return retData;
  }

  Future<dynamic> postBrandCouponAppData(Map data) async {
    //print('postBrandCouponAppData -> couponType:${data["COUPON_TYPE"]}, chainCode:${data["CHAIN_CODE"]}, orderMinAmt:${data["ORDER_MIN_AMT"]}, payMinAmt:${data["PAY_MIN_AMT"]}, deliveryYn:${data["DELIVERY_YN"]}, packYn:${data["PACK_YN"]}, displayStDate:${data["DISPLAY_ST_DATE"]}, displayExpDate:${data["DISPLAY_EXP_DATE"]}, insertUcode:${data["INS_UCODE"]}, insertName:${data["INS_NAME"]}, useYn:${data["USE_YN"]}');

    var result = await RestApiProvider.to.postBrandCouponApp(data["COUPON_TYPE"], data["CHAIN_CODE"], data["ORDER_MIN_AMT"], data["PAY_MIN_AMT"], data["DELIVERY_YN"], data["PACK_YN"], data["DISPLAY_ST_DATE"], data["DISPLAY_EXP_DATE"], data["INS_UCODE"], data["INS_NAME"], data["USE_YN"]);

    //print('postBrandCouponAppData -> ${result.bodyString}');

    if (result.body['code'] != '00') {
      //ISAlert(context, '회원 등록이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putBrandCouponAppData(Map data) async {
    String ucode = GetStorage().read('logininfo')['uCode'];
    String uname = GetStorage().read('logininfo')['name'];

    var result = await RestApiProvider.to.putBrandCouponApp(data["COUPON_TYPE"].toString(), data["ORDER_MIN_AMT"].toString(), data["PAY_MIN_AMT"].toString(),
        data["DELIVERY_YN"].toString(), data["PACK_YN"].toString(), data["DISPLAY_ST_DATE"].toString(), data["DISPLAY_EXP_DATE"].toString(), ucode, uname, data["USE_YN"].toString());

    if (result.body['code'] != '00') {
      //ISAlert(context, '회원 정보 수정이 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      return result.body['msg'];
    } else
      return;
  }

  deleteBrandCouponAppData(BuildContext context, String couponType) async {
    var result = await RestApiProvider.to.deleteBrandCouponApp(couponType);
    //print('===== ret body str->'+result.bodyString.toString());

    if (result.body['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }

    return result.body;
  }

  Future<dynamic> getBrandCouponAppDetail(String couponType) async {
    // var result = await RestApiProvider.to.getBrandCouponAppDetail(couponType);
    //
    // if (result.body['code'] == '00') {
    //   return result.body['data'];
    // } else
    //   return null;

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '/$couponType');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;
  }
}
