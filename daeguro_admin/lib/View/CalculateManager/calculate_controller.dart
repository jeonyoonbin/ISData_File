import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CalculateController extends GetxController with SingleGetTickerProviderMixin {
  static CalculateController get to => Get.find();
  BuildContext context;

  dynamic qDataDetail;

  int total_count = 0;
  int totalRowCnt = 0;

  // 잔액 총계
  int sumPreAmt = 0;

  // 기간별 입,출,잔액
  int sumInAmt = 0;
  int sumOutAmt = 0;
  int sumPreAmtIn = 0;

  // 가맹점 적립금 관리 합계(신규)
  RxInt all_amt = 0.obs;
  RxInt take_amt = 0.obs;
  RxInt remain_amt = 0.obs;
  RxInt all_amt_sum = 0.obs;
  RxInt in_amt_sum = 0.obs;
  RxInt p_amt_sum = 0.obs;
  RxInt k_amt_sum = 0.obs;
  RxInt take_count_sum = 0.obs;
  RxInt take_amt_sum = 0.obs;
  RxInt remain_amt_sum = 0.obs;

  // 주문번호별 정산금액 조회 SUM_COUNT
  RxInt count = 0.obs;
  RxInt comp = 0.obs;
  RxInt canc = 0.obs;
  RxInt sum_menu_amt = 0.obs;
  RxInt sum_deli_tip_amt = 0.obs;
  RxInt sum_tot_amt = 0.obs;
  RxInt sum_coupon_amt = 0.obs;
  RxInt sum_mileage_use_amt = 0.obs;
  RxInt sum_etc_disc_amt = 0.obs;
  RxInt sum_disc_amt = 0.obs;
  RxInt sum_amount = 0.obs;
  RxInt sum_pgm_amt = 0.obs;
  RxInt sum_pg_pgm_amt = 0.obs;
  RxInt sum_pgm_sum_amt = 0.obs;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxString state = ''.obs;
  RxString divKey = ''.obs;
  RxString tel = ''.obs;
  RxString name = ''.obs;
  RxString rows = ''.obs;
  RxString page = ''.obs;
  RxString keyword = ''.obs;
  RxString memo = ''.obs;
  RxString chargeGbn = ''.obs;
  RxString testYn = ''.obs;

  List<dynamic> qData = [];
  List<dynamic> qCcList = [];
  List<dynamic> qCommissionList = [];

  @override
  void onInit() {
    rows.value = '15';
    page.value = '1';

    super.onInit();
  }

  getData(String mCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_SHOPMILEAGE +
        '?mcode=$mCode&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}&divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&memo=${memo.value.toString()}');

    qData.clear();
    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);

      totalRowCnt = int.parse(response.data['count'].toString());
    } else
      return null;

    return qData;
  }

  Future<dynamic> getCount(String feeYm, String jobGbn) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_GETCOUNT + '?feeYm=$feeYm&jobGbn=$jobGbn');

    if (response.data['code'] == '00') {
      return response;
    }

    return null;
  }

  Future<List<dynamic>> getShopCalculateSum(String mCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_SHOPMILEAGESUM +
        '?mcode=$mCode&date_begin=' + startDate.value.toString() + '&date_end=' + endDate.value.toString() + '&divKey=' + divKey.value.toString() + '&keyword=' + name.value.toString());

    all_amt.value = int.parse(response.data['total']['ALL_AMT'].toString());
    take_amt.value = int.parse(response.data['total']['TAKE_AMT'].toString());
    remain_amt.value = int.parse(response.data['total']['REMAIN_AMT'].toString());

    all_amt_sum.value = int.parse(response.data['sum']['ALL_AMT_SUM'].toString());
    in_amt_sum.value = int.parse(response.data['sum']['IN_AMT_SUM'].toString());
    p_amt_sum.value = int.parse(response.data['sum']['P_AMT_SUM'].toString());
    k_amt_sum.value = int.parse(response.data['sum']['K_AMT_SUM'].toString());
    take_count_sum.value = int.parse(response.data['sum']['TAKE_COUNT_SUM'].toString());
    take_amt_sum.value = int.parse(response.data['sum']['TAKE_AMT_SUM'].toString());
    remain_amt_sum.value = int.parse(response.data['sum']['REMAIN_AMT_SUM'].toString());

    return null;
  }

  Future<List<dynamic>> getCcMileageData(String mCode, String ccCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_CCMILEAGE +
        '?mcode=$mCode&cccode=$ccCode&date_begin=' + startDate.value.toString() + '&date_end=' + endDate.value.toString() + '&keyword=' + name.value.toString() + '&memo=' + memo.value.toString() + '&page=' + page.value.toString() + '&rows=' + rows.value.toString() + '&test_yn=' + testYn.value.toString());

    //total_count = int.parse(result.body['totalCount']['COUNT'].toString());
    totalRowCnt = int.parse(response.data['count'].toString());

    if (response.data['code'] == '00') {
      qCcList.assignAll(response.data['data']);
      // print(qCcList);
    } else
      return null;

    return qCcList;
  }

  Future<List<dynamic>> getCcMileageDataSum(String mCode, String ccCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_CCMILEAGESUM + '?mcode=$mCode&cccode=$ccCode&test_yn=${testYn.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&keyword=${name.value.toString()}&memo=${memo.value.toString()}');

    //총 잔액
    sumPreAmt = int.parse(response.data['total'].toString());

    //기간별
    sumInAmt = int.parse(response.data['count']['SUM_IN_AMT'].toString());
    sumOutAmt = int.parse(response.data['count']['SUM_OUT_AMT'].toString());
    sumPreAmtIn = int.parse(response.data['count']['SUM_PRE_AMT'].toString());

    return null;
  }

  getCommissionData(String mCode) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_COMMISSION + '?mcode=$mCode&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&charge_gbn=${chargeGbn.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    //total_count = int.parse(result.body['totalCount'].toString());
    totalRowCnt = int.parse(response.data['count'].toString());

    if (response.data['code'] == '00') {
      qCommissionList.assignAll(response.data['data']);
      // print(qCommissionList);
    } else
      return null;

    return qCommissionList;
  }

  getOrderCalculateList(String mCode, String status, String payGbn, String date_begin, String date_end, String div_key, String keyword, String page, String rows) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_GETORDERCALCULATELIST +
        '?mcode=$mCode&status=$status&payGbn=$payGbn&date_begin=$date_begin&date_end=$date_end&divKey=$div_key&keyword=$keyword&page=$page&rows=$rows');

    //total_count = int.parse(result.body['totalCount'].toString());
    totalRowCnt = int.parse(response.data['count'].toString());

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    } else
      return null;

    return qData;
  }

  getOrderCalculateSum(String mCode, String status, String payGbn, String date_begin, String date_end, String div_key, String keyword) async {
    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_GETORDERCALCULATESUM +
        '?mcode=$mCode&status=$status&payGbn=$payGbn&date_begin=$date_begin&date_end=$date_end&divKey=$div_key&keyword=$keyword');


    // 합계
    count.value = response.data['count']['COUNT'];
    comp.value = response.data['count']['COMP'];
    canc.value = response.data['count']['CANC'];
    sum_menu_amt.value = response.data['count']['SUM_MENU_AMT'];
    sum_deli_tip_amt.value = response.data['count']['SUM_DELI_TIP_AMT'];
    sum_tot_amt.value = response.data['count']['SUM_TOT_AMT'];
    sum_coupon_amt.value = response.data['count']['SUM_COUPON_AMT'];
    sum_mileage_use_amt.value = response.data['count']['SUM_MILEAGE_USE_AMT'];
    sum_etc_disc_amt.value = response.data['count']['SUM_ETC_DISC_AMT'];
    sum_disc_amt.value = response.data['count']['SUM_DISC_AMT'];
    sum_amount.value = response.data['count']['SUM_AMOUNT'];
    sum_pgm_amt.value = response.data['count']['SUM_PGM_AMT'];
    sum_pg_pgm_amt.value = response.data['count']['SUM_PG_PGM_AMT'];
    sum_pgm_sum_amt.value = response.data['count']['SUM_PGM_SUM_AMT'];
  }

  postShopCharge(BuildContext context, String mCode, String ccCode, String shopCd, String ioGbn, String amt, String memo, String ucode) async {
    var response = await DioClient().post(ServerInfo.REST_URL_CALCULATE_INSERTSHOPCHARGE + '?mcode=$mCode&cccode=$ccCode&shopCd=$shopCd&ioGbn=$ioGbn&amt=$amt&memo=$memo&ucode=$ucode');

    if (response.data['code'] != '00') {
      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    }
  }

  Future<dynamic> postInsertTaxMastData(String div, String jobGbn, String feeYm, String memo, String modUcode, String modName, List data) async {
    final response = await DioClient().post(ServerInfo.REST_URL_CALCULATE_INSERTTAXMAST + '?jobGbn=$jobGbn&div=$div&feeYm=$feeYm&memo=$memo&modUcode=$modUcode&modName=$modName', data: data);

    if (response.data['code'] == '00') {
      //print('===== before Order getData()-> '+ response.data['msg'].toString());
      return response.data['code'];
    }
    else
      return null;
  }

  Future<dynamic> putTaxBillData(String jobGbn, String jobGbn2, String div, String feeYm, String sendType, String modUcode, String modName, List data) async {
    final response = await DioClient().put(ServerInfo.REST_URL_CALCULATE_TAXBILL + '?jobGbn=$jobGbn&jobGbn2=$jobGbn2&div=$div&feeYm=$feeYm&sendType=$sendType&modUcode=$modUcode&modName=$modName', data: data);

    if (response.data['code'] == '00') {
      //print('===== before Order getData()-> '+ response.data['msg'].toString());
      return response.data['code'];
    }
    else
      return null;
  }

  Future<List<dynamic>> getSearchShopTaxData(String fee_ym, String mcode, String chargeGbn, String gbn, String prtYn, String shop_name, String page, String rows) async {
    List<dynamic> qSearchShopTaxList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_SEARCHSHOPTAX + '?fee_ym=$fee_ym&mcode=$mcode&chargeGbn=$chargeGbn&gbn=$gbn&prtYn=$prtYn&shopName=$shop_name&page=$page&rows=$rows');

    if (response.data['code'] == '00') {
      qSearchShopTaxList.assignAll(response.data['data']);

      totalRowCnt = int.parse(response.data['count'].toString());

      return qSearchShopTaxList;
    }
    else
      return null;
  }

  Future<List<dynamic>> getTaxLogData(String div, String error_gbn) async {
    List<dynamic> qSearchShopTaxList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_CALCULATE_TAXLOG + '?div=$div&error_gbn=$error_gbn&divKey=${divKey.value.toString()}&keyword=${name.value.toString()}&date_begin=${startDate.value.toString()}&date_end=${endDate.value.toString()}&page=${page.value.toString()}&rows=${rows.value.toString()}');

    if (response.data['code'] == '00') {
      qSearchShopTaxList.assignAll(response.data['data']);

      //print('===== before getTaxLogData()-> '+ response.data['data'].toString());

      totalRowCnt = int.parse(response.data['count'].toString());

      return qSearchShopTaxList;
    }
    else
      return null;
  }
}