
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StatController extends GetxController with SingleGetTickerProviderMixin {
  static StatController get to => Get.find();
  BuildContext context;

  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getShopTotalOrderData(String gungu) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPTOTALORDER + '?gungu=$gungu&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopTypeData(String startDate, String endDate) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPTYPE + '?date_begin=$startDate&date_end=$endDate');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopSalesData(String startDate, String endDate) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPSALES + '?date_begin=$startDate&date_end=$endDate');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopGunguData(String divKey) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPGUNGU + '?divKey=$divKey&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopCategoryData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPCATEGORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerDailyData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_CUSTOMERDAILY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getNonCustomerDailyData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_NONCUSTOMERDAILY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerOrderData() async {
    List<dynamic> retData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_STAT_CUSTOMERORDER + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getCustomerRankOrderData() async {
    List<dynamic> retData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_STAT_CUSTOMERRANKORDER + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderCategoryData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_ORDERCATEGORY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderTimeData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_ORDERTIME + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderPayData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_ORDERPAY + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getOrderGunguData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_ORDERGUNGU + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderCompletedCanceled() async {
    List<dynamic> retData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_STAT_DAILYORDER_COMPLETEDCANCELED + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderPayGbn() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_DAILYORDER_PAYGBN + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyOrderCancelReason() async {
    List<dynamic> retData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_STAT_DAILYORDER_CANCELREASON + '?date_begin=' + fromDate.value.toString() + '&date_end=' + toDate.value.toString());

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopTypeDetailData(String gungu, String startDate, String endDate) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPTYPE_GUNGU + '/$gungu?date_begin=$startDate&date_end=$endDate');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getShopSalesDetailData(String gungu, String startDate, String endDate) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPSALES_DETAIL + '/$gungu?date_begin=$startDate&date_end=$endDate');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;

  }

  Future<List<dynamic>> getDailyAgeToOrderData() async {
    List<dynamic> retData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_STAT_DAILYAGE_TO_ORDER + '?date_begin=' + fromDate.value.toString() +'&date_end=' + toDate.value.toString());

    if (response.data['code'] == '00')
      retData.assignAll(response.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyEventCountData() async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_SHOPEVENTCOUNT + '?date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDrgCouponData(String couponName) async {
    final result = await DioClient().get(ServerInfo.REST_URL_STAT_DRGCOUPON + '?coupon_name=$couponName');

    if (result.data['code'] == '00')
      return result.data['data'];//retData.assignAll(result.data['data']);
    else
      return null;

    //return retData;
  }

  Future<List<dynamic>> getDrgCouponDetailData(String mon, String couponName) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_DRGCOUPON + '/$mon?coupon_name=$couponName');

    if (result.data['code'] == '00')
      return result.data['data'];
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getDailyDrgCouponData(String type, String coupon_type) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_DAILYDRGCOUPON + '?type=$type&coupon_type=$coupon_type&date_begin=${fromDate.value.toString()}&date_end=${toDate.value.toString()}');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageInOutMonthData(String startDate, String endDate, String custGbn) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_MILEAGEINOUTMONTH + '?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageInOutMonthDetailData(String startDate, String endDate, String custGbn, String dateYm) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_MILEAGEINOUTDAY + '/$dateYm?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageSaleInOutMonthData(String startDate, String endDate, String custGbn, String saleGbn) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTMONTH + '?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn&sale_gbn=$saleGbn');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  Future<List<dynamic>> getMileageSaleInOutMonthDetailData(String startDate, String endDate, String custGbn, String dateYm, String saleGbn) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTDAY + '/$dateYm?date_begin=$startDate&date_end=$endDate&cust_gbn=$custGbn&sale_gbn=$saleGbn');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }
}
