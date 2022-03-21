import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StatController extends GetxController with SingleGetTickerProviderMixin {
  static StatController get to => Get.find();
  BuildContext context;

  //List<dynamic> qData = [];
  //List<dynamic> qDetailData = [];

  //List<dynamic> qDataSales = [];

  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    //getData(context);

    super.onInit();
  }

  Future<List<dynamic>> getShopTotalOrderData(String gungu) async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatShopTotalOrder(gungu, fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPTOTALORDER + '?gungu=$gungu&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopTypeData(String startDate, String endDate) async {
    // qData.clear();
    //
    // var result = await RestApiProvider.to.getStatShopType(startDate, endDate);
    //
    // qData.assignAll(result.body['data']);

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPTYPE + '?date_begin=$startDate&date_end=$endDate');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopSalesData(String startDate, String endDate) async {
    // qDataSales.clear();
    //
    // var result = await RestApiProvider.to.getStatShopSales(startDate, endDate);
    //
    // qDataSales.assignAll(result.body['data']);

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPSALES + '?date_begin=$startDate&date_end=$endDate');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopGunguData(String divKey) async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getShopGungu(divKey, fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPGUNGU + '?divKey=$divKey&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopCategoryData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getShopCategory(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPCATEGORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerDailyData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatCustomerDaily(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_CUSTOMERDAILY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getNonCustomerDailyData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatNonCustomerDaily(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_NONCUSTOMERDAILY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerOrderData() async {
    List<dynamic> retData = [];

    //var result = await RestApiProvider.to.getStatCustomerOrder(fromDate.value.toString(), toDate.value.toString());

    // dio 패키지 조회
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_STAT_CUSTOMERORDER + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerRankOrderData() async {
    List<dynamic> retData = [];

    //var result = await RestApiProvider.to.getStatCustomerRankOrder(fromDate.value.toString(), toDate.value.toString());

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_STAT_CUSTOMERRANKORDER + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderCategoryData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatOrderCategory(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_ORDERCATEGORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderTimeData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatOrderTime(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_ORDERTIME + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderPayData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatOrderPay(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_ORDERPAY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderGunguData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatOrderGungu(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_ORDERGUNGU + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderCompletedCanceled() async {
    List<dynamic> retData = [];

    //var result = await RestApiProvider.to.getStatOrderDailyCompletedCanceled(fromDate.value.toString(), toDate.value.toString());

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_STAT_DAILYORDER_COMPLETEDCANCELED + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderPayGbn() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatOrderDailyPayGbn(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_DAILYORDER_PAYGBN + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderCancelReason() async {
    List<dynamic> retData = [];

    //var result = await RestApiProvider.to.getStatOrderDailyCancelReason(fromDate.value.toString(), toDate.value.toString());

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_STAT_DAILYORDER_CANCELREASON + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopTypeDetailData(String gungu, String startDate, String endDate) async {
    // List<dynamic> tempRetData = [];
    //
    // var result = await RestApiProvider.to.getStatShopTypeDetail(gungu, startDate, endDate);
    //
    // tempRetData.assignAll(result.body['data']);
    //
    // return tempRetData;

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPTYPE_GUNGU + '/$gungu?date_begin=$startDate&date_end=$endDate');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;

  }

  Future<List<dynamic>> getShopSalesDetailData(String gungu, String startDate, String endDate) async {
    // List<dynamic> tempRetData = [];
    //
    // var result = await RestApiProvider.to.getStatShopSalesDetail(gungu, startDate, endDate);
    //
    // tempRetData.assignAll(result.body['data']);
    //
    // return tempRetData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPSALES_DETAIL + '/$gungu?date_begin=$startDate&date_end=$endDate');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;

  }

  Future<List<dynamic>> getDailyAgeToOrderData() async {
    List<dynamic> retData = [];

    //var result = await RestApiProvider.to.getDailyAgeToOrder(fromDate.value.toString(), toDate.value.toString());

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_STAT_DAILYAGE_TO_ORDER + '?date_begin=' + fromDate.value.toString() +'&date_end=' + toDate.value.toString());

    dio.clear();
    dio.close();

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyEventCountData() async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getDailyEventCount(fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;


    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_SHOPEVENTCOUNT + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDrgCouponData(String couponName) async {
    //qData.clear();

    //var result = await RestApiProvider.to.getStatCouponDrgCoupon(couponName);

    //return result.body['data'];

    //List<dynamic> retData = [];

    var dio = Dio();
    //var result = await RestApiProvider.to.getMileageSaleInOutDay(startDate, endDate, custGbn, dateYm, saleGbn);
    final result = await dio.get(ServerInfo.REST_URL_STAT_DRGCOUPON + '?coupon_name=$couponName');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      return result.data['data'];//retData.assignAll(result.data['data']);
    else
      return null;

    //return retData;
  }

  Future<List<dynamic>> getDrgCouponDetailData(String mon, String couponName) async {
    // qData.clear();
    //
    // var result = await RestApiProvider.to.getStatCouponDrgCouponDetail(mon, couponName);
    //
    // return  result.body['data'];

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_DRGCOUPON + '/$mon?coupon_name=$couponName');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyDrgCouponData(String type, String coupon_type) async {
    // List<dynamic> retData = [];
    //
    // var result = await RestApiProvider.to.getStatCouponDailyDrgCoupon(type, coupon_name, fromDate.value.toString(), toDate.value.toString());
    //
    // if (result.body['code'] == '00')
    //   retData.assignAll(result.body['data']);
    // else
    //   return null;
    //
    // return retData;

    //

    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_DAILYDRGCOUPON + '?type=$type&coupon_type=$coupon_type&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageInOutMonthData(String startDate, String endDate, String custGbn) async {
    List<dynamic> retData = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_STAT_MILEAGEINOUTMONTH + '?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageInOutMonthDetailData(String startDate, String endDate, String custGbn, String dateYm) async {
    List<dynamic> retData = [];

    var dio = Dio();
    //var result = await RestApiProvider.to.getMileageInOutDay(startDate, endDate, custGbn, dateYm);
    final result = await dio.get(ServerInfo.REST_URL_STAT_MILEAGEINOUTDAY + '/$dateYm?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageSaleInOutMonthData(String startDate, String endDate, String custGbn, String saleGbn) async {
    List<dynamic> retData = [];

    var dio = Dio();
    //var result = await RestApiProvider.to.getMileageSaleInOutMonth(startDate, endDate, custGbn, saleGbn);
    final result = await dio.get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTMONTH + '?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn&sale_gbn=$saleGbn');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageSaleInOutMonthDetailData(String startDate, String endDate, String custGbn, String dateYm, String saleGbn) async {
    List<dynamic> retData = [];

    var dio = Dio();
    //var result = await RestApiProvider.to.getMileageSaleInOutDay(startDate, endDate, custGbn, dateYm, saleGbn);
    final result = await dio.get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTDAY + '/$dateYm?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn&sale_gbn=$saleGbn');

    dio.clear();
    dio.close();

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }
}
